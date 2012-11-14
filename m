Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab2KNI0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:26:20 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37068 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab2KNI0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:26:19 -0500
X-Greylist: delayed 24547 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2012 03:26:18 EST
X-AuditID: b753bd60-96850ba000002f78-c8-50a355a881ba
X-AuditID: b753bd60-96850ba000002f78-c8-50a355a881ba
Message-ID: <50A355A2.5040101@hitachi.com>
Date: Wed, 14 Nov 2012 17:26:10 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
References: <20121114013611.5338.15086.stgit@yunodevel>  <1352858437.18025.47.camel@gandalf.local.home>  <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com> <1352860305.18025.48.camel@gandalf.local.home>
In-Reply-To: <1352860305.18025.48.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for commenting on my patch set.

(2012/11/14 11:31), Steven Rostedt wrote:
> On Tue, 2012-11-13 at 18:03 -0800, David Sharp wrote:
>> On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
>>>
>>>> To merge the data like previous pattern, we apply this patch set. Then, we can
>>>> get TSC offset of the guest as follows:
>>>>
>>>> $ dmesg | grep kvm
>>>> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
>>>>                       ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
>>>>                       PID                         TSC offset                 |
>>>>                                                             HOST TSC value --+
>>>>
>>>
>>> Using printk to export something like this is IMO a nasty hack.
>>>
>>> Can't we create a /sys or /proc file to export the same thing?
>>
>> Since the value changes over the course of the trace, and seems to be
>> part of the context of the trace, I think I'd include it as a
>> tracepoint.
>>
>
> I'm fine with that too.

Using some tracepoint is a nice idea, but there is one problem. Here,
our discussion point is "the event which TSC offset is changed does not
frequently occur, but the buffer must keep the event data."

There are two ideas for using tracepoint. First, we define new
tracepoint for changed TSC offset. This is simple and the overhead will
be low. However, this trace event stored in the buffer will be
overwritten by other trace events because this TSC offset event does
not frequently occur. Second, we add TSC offset information to the
tracepoint frequently occured. For example, we assume that TSC offset
information is added to arguments of trace_kvm_exit(). By adding the
information to the arguments, we can avoid the situation where the TSC
offset information is overwritten by other events. However, TSC offset
is not frequently changed and same information is output many times
because almost all data are waste. Therefore, only using tracepoint
is not good idea.

So, I suggest a hybrid method; record TSC offset change events and read
the last TSC offset from procfs when collecting the trace data.
In particular, the method is as follows:
  1. Enable the tracepoint of TSC offset change and record the value
     before and after changing
  2. Start tracing
  3. Stop tracing
  4. Collect trace data and read /proc/pid/kvm/*
  5. Check if any trace event recording the two TSC offsets exists
     in the trace data
     if(existing) => use trace event (flow 6)
     else         => use /proc/pid/kvm/* (flow 7)
  6. Apply two TSC offsets of the trace event to the trace data and
     sort the trace data
　　(Ex.)
         * => tracepoint of changing TSC offset
         . => another trace event

　　[START]............*............[END]
          <----------> <---------->
            previous      current
           TSC offset   TSC offset

  7. Apply TSC offset of /proc/pid/kvm/* to the trace data and
     sort the trace data
    (Ex.)
         . => another trace event(not tracepoint of changing TSC offset)

　　[START].........................[END]
          <----------------------->
                  current
                TSC offset

Thanks,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


