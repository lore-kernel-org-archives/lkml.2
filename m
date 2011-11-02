Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1KBXAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:00:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1KBXAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:00:11 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=wom5GMh1gUkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=1uEGqAuTlE5yzDl1I-4A:9 a=K1zGq31wSIvENhwVuVIA:7 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Wed, 2 Nov 2011 19:00:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111102230009.GB27457@home.goodmis.org>
References: <1318879396.4172.92.camel@twins>
 <alpine.LFD.2.02.1110172237030.3240@ionos>
 <alpine.LFD.2.02.1110181037120.3240@ionos>
 <1318928713.21167.4.camel@twins>
 <20111018182046.GF1309@hostway.ca>
 <alpine.LFD.2.02.1110182146440.3240@ionos>
 <20111024190203.GA24410@hostway.ca>
 <20111025202049.GB25043@hostway.ca>
 <20111031173246.GA10614@hostway.ca>
 <20111102221023.GA27457@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102221023.GA27457@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 06:10:23PM -0400, Steven Rostedt wrote:
> Thomas pointed me here.
> 
> On Mon, Oct 31, 2011 at 10:32:46AM -0700, Simon Kirby wrote:
> > [104661.244767] 
> > [104661.244767]  Possible unsafe locking scenario:
> > [104661.244767]        
> > [104661.244767]        CPU0                    CPU1
> > [104661.244767]        ----                    ----
> > [104661.244767]   lock(slock-AF_INET);
> > [104661.244767]                                lock(slock-AF_INET);
> > [104661.244767]                                lock(slock-AF_INET);
> > [104661.244767]   lock(slock-AF_INET);
> > [104661.244767] 
> > [104661.244767]  *** DEADLOCK ***
> > [104661.244767] 
> 
> Bah, I used the __print_lock_name() function to show the lock names in
> the above, which leaves off the subclass number. I'll go write up a
> patch that fixes that.
> 

Simon,

If you are still triggering the bug. Could you do me a favor and apply
the following patch. Just to make sure it fixes the confusing output
from above.

Thanks,

-- Steve


diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 91d67ce..d821ac9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -490,16 +490,22 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 	usage[i] = '\0';
 }
 
-static int __print_lock_name(struct lock_class *class)
+static void __print_lock_name(struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN];
 	const char *name;
 
 	name = class->name;
-	if (!name)
+	if (!name) {
 		name = __get_key_name(class->key, str);
-
-	return printk("%s", name);
+		printk("%s", name);
+	} else {
+		printk("%s", name);
+		if (class->name_version > 1)
+			printk("#%d", class->name_version);
+		if (class->subclass)
+			printk("/%d", class->subclass);
+	}
 }
 
 static void print_lock_name(struct lock_class *class)
@@ -509,17 +515,8 @@ static void print_lock_name(struct lock_class *class)
 
 	get_usage_chars(class, usage);
 
-	name = class->name;
-	if (!name) {
-		name = __get_key_name(class->key, str);
-		printk(" (%s", name);
-	} else {
-		printk(" (%s", name);
-		if (class->name_version > 1)
-			printk("#%d", class->name_version);
-		if (class->subclass)
-			printk("/%d", class->subclass);
-	}
+	printk(" (");
+	__print_lock_name(class);
 	printk("){%s}", usage);
 }
 
