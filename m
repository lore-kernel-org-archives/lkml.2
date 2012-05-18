Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab2ERWR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:17:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55500 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab2ERWRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <201205182346.02296.rjw@sisk.pl>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
 <1337375946.7562.11.camel@gandalf.stny.rr.com> <CANMivWZ4ygG5R7ob_Q-pkAFpoKAkK_iQf3w2eiw5Gv65AbTYNw@mail.gmail.com>
 <201205182346.02296.rjw@sisk.pl>
From: Sameer Nanda <snanda@chromium.org>
Date: Fri, 18 May 2012 15:17:32 -0700
X-Google-Sender-Auth: M4sUuqc6WHmu9txUfeuMZPQ-LaY
Message-ID: <CANMivWafYv8BU2_ez==+GGYWn54BM+iU6u7yLLs-2TOfm-1ftA@mail.gmail.com>
Subject: Re: [PATCH] power, trace: add tracing for device_resume
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@linuxfoundation.org>,
        rob@landley.net, len.brown@intel.com, pavel@ucw.cz, fweisbec@gmail.com,
        mingo@redhat.com, jkosina@suse.cz, standby24x7@gmail.com,
        jj@chaosbits.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 2:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 18, 2012, Sameer Nanda wrote:
>> On Fri, May 18, 2012 at 2:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Fri, 2012-05-18 at 13:58 -0700, Sameer Nanda wrote:
>> >> On Fri, May 18, 2012 at 12:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >> > On Fri, 2012-05-18 at 11:57 -0700, Sameer Nanda wrote:
>> >> >
>> >> >> AFAICT, they are used for something completely different -- help solve
>> >> >> suspend/resume issues by saving a hash in the RTC of the last device
>> >> >> that suspended/resumed.  They don't use the perf tracing mechanism at
>> >> >> all.
>> >> >>
>> >> >
>> >> > Also note that all tracepoints have timestamps attached to them. You do
>> >> > not need to add deltas. Do that in the userspace tools that read the
>> >> > timestamps and events. This way you can have one DECLARE_EVENT_CLASS and
>> >> > three DEFINE_EVENTs. This will save space.
>> >>
>> >> Agreed on the space savings.  However, with the time_delta in the
>> >> trace message itself, a one line shell script [1] that sorts on the
>> >> time_delta field is sufficient to quickly spot the devices that take a
>> >> long time to resume.  Without the time_delta field, the user tool is
>> >> more complex since it needs to first match up the device_resume_in,
>> >> device_resume_waited and device_resume_out traces and then calculate
>> >> time deltas.
>> >>
>> >> Seems like a worthwhile trade-off to me but I can take out the
>> >> time_delta if the general consensus is otherwise.
>> >
>> > Just note that every TRACE_EVENT() adds around 5k or more code. Every
>> > DEFINE_EVENT adds just about 300 bytes.
>>
>> Ok, let me respin the patch.  I am thinking of adding time_delta to
>> all three traces.  That way we should get the space saving while still
>> allowing quick spotting of devices that take long time to resume.
>
> Well, what's wrong with the code in drivers/base/power/main.c that
> is activated by adding initcall_debug to the kernel command line?

Mostly that I hadn't looked closely at initcall_debug before writing my patch :)

Now that I have taken a look at it, the main issue is that the kernel
command line needs to be modified to activate it.  We cannot do this
for our automated regression suites since the kernel command line is
protected on Chrome OS systems.

Does it make sense to merge these tracepoints with initcall_debug
then?  The initcall_debug prints will still be conditional on the
kernel command line flag but the tracepoints wouldn't be.

Another possibility is to convert initcall_debug to use tracepoints
instead of printks.  But I am not sure if this would break any
existing tools that depend on initcall_debug on resume path?

>
> Rafael



-- 
Sameer
