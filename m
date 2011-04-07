Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab1DGAav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:30:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60770 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab1DGAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:30:50 -0400
Date: Wed, 6 Apr 2011 17:30:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110407003041.GD2265@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1301570320.4859.242.camel@twins>
 <4D953121.6090901@cn.fujitsu.com>
 <1301657749.4859.531.camel@twins>
 <20110405215450.GK2247@linux.vnet.ibm.com>
 <20110405230745.GA5972@linux.vnet.ibm.com>
 <1302077428.2225.1365.camel@twins>
 <20110406192119.GB2265@linux.vnet.ibm.com>
 <20110406201350.GA9378@linux.vnet.ibm.com>
 <1302123970.2207.4.camel@laptop>
 <4D9CDACB.9050705@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9CDACB.9050705@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 02:27:39PM -0700, H. Peter Anvin wrote:
> On 04/06/2011 02:06 PM, Peter Zijlstra wrote:
> > On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
> >> And the following patch builds correctly for defconfig x86 builds,
> >> while allowing rcupdate.h to see the sched.h definitions as needed
> >> to inline rcu_read_lock() and rcu_read_unlock().
> >>
> > Looks like an entirely reasonable patch to me ;-)
> > 
> 
> Quite... a lot better than the original proposal!

Glad you both like it!

When I do an allyesconfig build, I do get errors during the "CHECK"
phase, when it is putting things into the usr/include in the build tree.
I believe that this is because I am exposing different header files to
the library-export scripts.  The following patch silences some of them,
but I am really out of my depth here.

Sam, Jan, Michal, help?

							Thanx, Paul

------------------------------------------------------------------------

rcu: cleanups in CHECK portion of kernel build

Silence some complaints about kernel-only functionality being exposed
to userspace.

Not-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 00cec4d..a243c13 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -648,6 +648,8 @@ struct sysinfo {
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
+#ifdef __KERNEL__
+
 /**
  * BUILD_BUG_ON - break compile if a condition is true.
  * @condition: the condition which the compiler should know is false.
@@ -673,6 +675,7 @@ extern int __build_bug_on_failed;
 		if (condition) __build_bug_on_failed = 1;	\
 	} while(0)
 #endif
+#endif /* __KERNEL__ */
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
diff --git a/include/linux/soundcard.h b/include/linux/soundcard.h
index 1904afe..f99c32f 100644
--- a/include/linux/soundcard.h
+++ b/include/linux/soundcard.h
@@ -1064,7 +1064,9 @@ typedef struct mixer_vol_table {
  */
 #define SEQ_DECLAREBUF()		SEQ_USE_EXTBUF()
 
+#ifdef __KERNEL__
 void seqbuf_dump(void);	/* This function must be provided by programs */
+#endif
 
 #define SEQ_PM_DEFINES int __foo_bar___
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index be80a59..92fb6fa 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -19,7 +19,9 @@
  ****************************************************************
  */
 
+#ifdef __KERNEL__
 #include <linux/key.h>
+#endif
 
 #ifndef _LINUX_SYSCTL_H
 #define _LINUX_SYSCTL_H
