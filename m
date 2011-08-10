Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1HJShR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:37:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61111 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1HJShP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <87wrel5gp8.fsf@skywalker.in.ibm.com>
References: <1312200884-20110-1-git-send-email-ajray@ncsu.edu>
 <877h6l7hoj.fsf@skywalker.in.ibm.com> <CAFkjPT=y4jJTNEFrJLr=i9UVHfixqqGmYbVZf0B4AHk-AmOJdA@mail.gmail.com>
 <87wrel5gp8.fsf@skywalker.in.ibm.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Wed, 10 Aug 2011 13:36:52 -0500
Message-ID: <CAFkjPT=ePtKi0Z-AjBm_W38VPTV3HbT6hWSMHOHezytoqAbNvQ@mail.gmail.com>
Subject: Re: [PATCH] 9p: remove CONFIG_NET_9P_DEBUG option
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alex Ray <alexjray.ncsu@gmail.com>, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Ray <ajray@ncsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 12:17 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, 10 Aug 2011 07:24:56 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>> On Wed, Aug 10, 2011 at 4:13 AM, Aneesh Kumar K.V
>> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> > On Mon,  1 Aug 2011 07:14:44 -0500, Alex Ray <alexjray.ncsu@gmail.com> wrote:
>> >> Remove the CONFIG_NET_9P_DEBUG option, used to completely remove logging
>> >> functionality from v9fs.  Logging is (already) controlled with the
>> >> run-time debug= option, this gets rid of the compile-time option (which
>> >> was being misunderstood and misused).
>> >>
>> >> Signed-off-by: Alex Ray <ajray@ncsu.edu>
>> >
>> > I see this merged to for-next.  Do we know whether enabling debug always have a
>> > performance impact ?.
>> >
>>
>> No clue, but without any debug it makes it impossible for user's to
>> generate reasonable bug reports.  If I understand the tracepoint
>> collection facility correctly, it incurs exactly the same overhead as
>> a DPRINT when the debug mount option is set to 0 (although tracepoints
>> are much lower overhead when actually collecting).
>
> I was worried about overhead when we are not collecting any debug info.
>

I understand that.  But the overhead when not collecting is the
conditional branch.
According to Documentation/trace/tracepoints.txt this is the same for the
tracepoints:

"When a tracepoint is "off" it has no effect, except for adding a tiny
time penalty
(checking a condition for a branch) and space penalty (adding a few
bytes for the function call at the end of the instrumented function
and adds a data structure in a separate section)."

So, since DPRINT is essentially if(p9_debug_level & level) == level)
it should roughly amount to the same overhead, no?  I suppose we could
get fancy and and prefix it with an unlikely.

> I actually converted protocol dump to tracepoints. Other advantages
> of switching to tracepoints is the ability to get stack trace,
> filtering debug output per mount points, integration with perf tool.

tracepoints definitely seem to be a win with the extra information, but
I worry about the average user being able to actually use the facility
to provide reasonable bug reports.  Are tracepoints going to be enabled
in all stock kernels and their tools available by default in a distribution,
or is this something we are going to have to step people through?

The middle ground may be to include DPRINT's for the absolute
minimum info for identifying bugs (maybe just P9_DEBUG_ERROR,
P9_DEBUG_9P and/or P9_DEBUG_VFS class messages) and convert
everything else to tracepoints and maybe prune a bit as well.

So, to demonstrate that I'm not just a lazy maintainer, I actually ran
a sniff test using both TCP and Virtio before/after the debug flag
patch and saw no statistically relevant difference between the two runs
when running the Bonnie benchmark suite. (any variation was so low
as to be attributable to noise as measured by having several successive
runs with each version).

       -eric
