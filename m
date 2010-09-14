Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0INNKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:10:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0INNKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:10:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Date: Tue, 14 Sep 2010 15:10:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <4C61EE55.5030506@codeaurora.org> <4C8EE708.5000109@codeaurora.org> <20100914082506.GA2201@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100914082506.GA2201@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141510.43446.arnd@arndb.de>
X-Provags-ID: V02:K0:iQ8v4n4TZwpIJBBffptTQNEC3mr2vaXQUGdtdk+tA8n
 CQOpRqczS2D8i8ft7c9EzNgSG7LkGagLYVKt4wZLIOjprFPjfJ
 zgaHX0Ia6R/LpZpde72kVNzRbFpY8KuavMq+bX0PQr88ExIqm0
 yMg1xAXKx572cYBgPKChBPTyJWEWk2kVDVW9OJjy7yT1f8jofv
 gQGlAYkeRSW/FHlTwSB9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 September 2010, Heiko Carstens wrote:
> On Mon, Sep 13, 2010 at 08:07:52PM -0700, Stephen Boyd wrote:
> > Changing the buf_size variable from an int to a size_t makes the warning
> > go away. Perhaps this is because gcc can't reliably eliminate the else
> > case when the lower bound isn't 0? Overflow? I'm not really sure. Does
> > the kernel/kprobes.c part of this patch work for you?
> 
> Yes, the warning goes away on s390 as well.

Ok, great!

In that case, I think we should just apply this patch to fix all these
warnings for good. There are probably some more in an x86_64 allyesconfig
build, but this should make s390 build cleanly again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 55f3a3e..0947e16 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1185,7 +1185,7 @@ static int set_offload(struct net_device *dev, unsigned long arg)
 }
 
 static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
-			    unsigned long arg, int ifreq_len)
+			    unsigned long arg, size_t ifreq_len)
 {
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 13776a7..6fff2f2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2388,7 +2388,7 @@ static ssize_t
 sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 		     size_t count, loff_t *off)
 {
-	int num;
+	size_t num;
 	unsigned long k = ULONG_MAX;
 	char buff[11];
 
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 1b4db2c..c085561 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -428,7 +428,7 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	size_t buf_size;
 	u32 *val = file->private_data;
 
 	buf_size = min(count, (sizeof(buf)-1));
diff --git a/net/compat.c b/net/compat.c
index 63d260e..4cc0ba9 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -774,7 +774,7 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 
 asmlinkage long compat_sys_socketcall(int call, u32 __user *args)
 {
-	int ret;
+	size_t ret;
 	u32 a[6];
 	u32 a0, a1;
 
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 10a1ea7..d9ee8b9 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -848,7 +848,8 @@ static ssize_t pktgen_if_write(struct file *file,
 {
 	struct seq_file *seq = file->private_data;
 	struct pktgen_dev *pkt_dev = seq->private;
-	int i = 0, max, len;
+	int i = 0, max;
+	size_t len;
 	char name[16], valstr[32];
 	unsigned long value = 0;
 	char *pg_result = NULL;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 9a17f28..fc1a4e0 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2062,7 +2062,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, char __user *optv
 static int packet_getsockopt(struct socket *sock, int level, int optname,
 			     char __user *optval, int __user *optlen)
 {
-	int len;
+	size_t len;
 	int val;
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);

