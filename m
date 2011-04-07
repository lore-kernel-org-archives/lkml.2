Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1DGFsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 01:48:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57877 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab1DGFsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 01:48:08 -0400
Message-ID: <4D9D507F.2040006@cn.fujitsu.com>
Date: Thu, 07 Apr 2011 13:49:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <1301570320.4859.242.camel@twins> <4D953121.6090901@cn.fujitsu.com> <1301657749.4859.531.camel@twins> <20110405215450.GK2247@linux.vnet.ibm.com> <20110405230745.GA5972@linux.vnet.ibm.com> <1302077428.2225.1365.camel@twins> <20110406192119.GB2265@linux.vnet.ibm.com> <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop> <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com>
In-Reply-To: <20110407003041.GD2265@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 13:48:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 13:48:50,
	Serialize complete at 2011-04-07 13:48:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 08:30 AM, Paul E. McKenney wrote:
> On Wed, Apr 06, 2011 at 02:27:39PM -0700, H. Peter Anvin wrote:
>> On 04/06/2011 02:06 PM, Peter Zijlstra wrote:
>>> On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
>>>> And the following patch builds correctly for defconfig x86 builds,
>>>> while allowing rcupdate.h to see the sched.h definitions as needed
>>>> to inline rcu_read_lock() and rcu_read_unlock().
>>>>
>>> Looks like an entirely reasonable patch to me ;-)
>>>
>>
>> Quite... a lot better than the original proposal!
> 
> Glad you both like it!
> 
> When I do an allyesconfig build, I do get errors during the "CHECK"
> phase, when it is putting things into the usr/include in the build tree.
> I believe that this is because I am exposing different header files to
> the library-export scripts.  The following patch silences some of them,
> but I am really out of my depth here.
> 
> Sam, Jan, Michal, help?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 

Easy to split rcupdate.h, hard to resolve the dependence problem.

You can apply the next additional patch when you test:

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0b4496a..ccbebeb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -788,4 +788,10 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
+#include <linux/sched.h>
+static inline long test_use_task_struct(void)
+{
+	return current->state;
+}
+
 #endif /* __LINUX_RCUPDATE_H */
