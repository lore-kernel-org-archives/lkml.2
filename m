Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2IYJA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:00:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13854 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2IYJAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:00:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,481,1344182400"; 
   d="scan'208";a="5912912"
Message-ID: <50617327.6000907@cn.fujitsu.com>
Date: Tue, 25 Sep 2012 17:02:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: restructure flush_workqueue() and start
 all flusher at the same time
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com> <20120924203954.GD29689@google.com>
In-Reply-To: <20120924203954.GD29689@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 17:00:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 17:00:35,
	Serialize complete at 2012/09/25 17:00:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 04:39 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Mon, Sep 24, 2012 at 06:07:02PM +0800, Lai Jiangshan wrote:
>> The core patch is patch6, it makes all flusher can start and the same time
>> and allow us do more cleanup.
>>
>> Only patch1 and patch6 change the behavior of the code.
>> All other patches do not change any behavior.
> 
> It would have been nice if you described what this patchset tries to
> achieve how in the head message.
> 
> I don't see anything wrong with the patchset but flush_workqueue() is
> quite hairy before this patchset and I'm not sure the situation
> improves a lot afterwards.  The current code is known / verified to
> work for quite some time and I'd *much* prefer to keep it stable
> unless it can be vastly simpler.

Hi, Tejun

I know your attitude, it is OK if you reject it.

I found the flush_workqueue() is not nature for me, especially
the usage of the colors and flush_workqueue_prep_cwqs().
so I try to improve it without change too much things/behavior.

(These patchset delay other simple patches, I think I should
send simple patches at first.)

> 
> I do like the removal of explicit cascading and would have gone that
> direction if this code is just being implemented but I'm quite
> skeptical whether changing over to that now is justifiable.  Flush
> bugs tend to be nasty and often difficult to track down.
> 
> I'll think more about it.  How confident are you about the change?
> How did you test them?  For changes like this, it usually helps a lot
> to describe how things were tested as part of head and/or commit
> messages.
> 

I always check the code by hard reviewing the code. I always try to image
there are many thread run in my brain orderless and I write all possible
transitions in paper. This progress is the most important, no test can
replace it.

Human brain can wrong, the attached patch is my testing code.
It verify flush_workqueue() by cookie number.

type "make test" to start the test.
type "Ctrl" and "c" to stop the test.

I also need your testing code for workqueue. ^_^

Thanks,
Lai

diff --git a/workqueue_flush_test/Makefile b/workqueue_flush_test/Makefile
new file mode 100644
index 0000000..3ecc7aa
--- /dev/null
+++ b/workqueue_flush_test/Makefile
@@ -0,0 +1,10 @@
+obj-m += wflush.o
+
+all:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
+
+clean:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
+
+test: all
+	bash ./test.sh
diff --git a/workqueue_flush_test/test.sh b/workqueue_flush_test/test.sh
new file mode 100644
index 0000000..a9d2d6a
--- /dev/null
+++ b/workqueue_flush_test/test.sh
@@ -0,0 +1,12 @@
+#/bin/bash
+
+make
+sync
+sync
+echo testing...
+trap 'echo interrupt test' INT
+sudo insmod wflush.ko
+sleep 60000
+sudo rmmod wflush.ko
+echo test done
+
diff --git a/workqueue_flush_test/wflush.c b/workqueue_flush_test/wflush.c
new file mode 100644
index 0000000..971e73d
--- /dev/null
+++ b/workqueue_flush_test/wflush.c
@@ -0,0 +1,129 @@
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/random.h>
+
+struct cookie_struct {
+	struct list_head head;
+	unsigned long cookie;
+};
+
+static DEFINE_MUTEX(cookie_lock);
+static unsigned long test_cookie;
+static LIST_HEAD(cookie_head);
+
+static unsigned long last_cookie(void)
+{
+	unsigned long cookie;
+
+	mutex_lock(&cookie_lock);
+	cookie = test_cookie - 1; /* c->cookie = test_cookie++; */
+	mutex_unlock(&cookie_lock);
+
+	return cookie;
+}
+
+static unsigned long tip_cookie(void)
+{
+	unsigned long cookie;
+
+	mutex_lock(&cookie_lock);
+	if (list_empty(&cookie_head))
+		cookie = test_cookie;
+	else
+		cookie = list_first_entry(&cookie_head, struct cookie_struct, head)->cookie;
+	mutex_unlock(&cookie_lock);
+
+	return cookie;
+}
+
+struct test_work {
+	struct work_struct w;
+	struct cookie_struct c;
+};
+
+static void add_test_work(struct test_work *t)
+{
+	struct cookie_struct *c = &t->c;
+
+	mutex_lock(&cookie_lock);
+	c->cookie = test_cookie++;
+	BUG_ON(!list_empty(&c->head));
+	list_add_tail(&c->head, &cookie_head);
+	schedule_work(&t->w);
+	mutex_unlock(&cookie_lock);
+
+	udelay(1+random32()%50);
+}
+
+static void test_work_fn(struct work_struct *w)
+{
+	struct test_work *t = container_of(w, struct test_work, w);
+
+	mutex_lock(&cookie_lock);
+	list_del_init(&t->c.head);
+	mutex_unlock(&cookie_lock);
+
+	udelay(1+random32()%50);
+}
+
+static int test_thread(void *arg)
+{
+	unsigned long lcookie, tcookie;
+	struct test_work t[10];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(t); i++) {
+		INIT_WORK_ONSTACK(&t[i].w, test_work_fn);
+		INIT_LIST_HEAD(&t[i].c.head);
+	}
+
+	do {
+		for (i = 0; i < ARRAY_SIZE(t); i++) {
+			add_test_work(t+i);
+		}
+
+		lcookie = last_cookie();
+		flush_scheduled_work();
+		tcookie = tip_cookie();
+		BUG_ON((long)(tcookie - lcookie) <= 0);
+	} while (!kthread_should_stop());
+	return 0;
+}
+
+static struct task_struct *test_tasks[100];
+
+static int test_init(void)
+{
+	int i;
+
+	printk(KERN_ERR "wflush test start\n");
+	for (i = 0; i < ARRAY_SIZE(test_tasks); i++) {
+		test_tasks[i] = kthread_run(test_thread, NULL, "wflush");
+		if (!test_tasks[i]) {
+			printk(KERN_ERR "wflush create fail %d\n", i);
+			break;
+		}
+	}
+
+	return 0;
+}
+module_init(test_init);
+
+static void test_exit(void)
+{
+	int i;
+
+	printk(KERN_ERR "wflush test stopping\n");
+	for (i = 0; i < ARRAY_SIZE(test_tasks); i++) {
+		if (test_tasks[i])
+			kthread_stop(test_tasks[i]);
+	}
+	printk(KERN_ERR "wflush test stopped\n");
+}
+module_exit(test_exit);
+
+MODULE_LICENSE("GPL");
