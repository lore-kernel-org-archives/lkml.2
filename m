Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0KENCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:02:38 -0400
Received: from mail.globalsuite.net ([69.46.103.200]:46608 "EHLO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KENCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:02:36 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 09:02:36 EDT
X-AuditID: c0a8013c-b7badae000000d22-66-4cd3f5e88444
Message-ID: <4CD3F25A.6070609@infradead.org>
Date: Fri, 05 Nov 2010 08:02:34 -0400
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: acme@infradead.org, fweisbec@gmail.com, mingo@elte.hu,
        peterz@infradead.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH 00/20] RAS daemon v3
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Em 04-11-2010 11:36, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi all,
> 
> I finally had some time to work on this thing again. This time it can
> parse the MCE tracepoint and should be conceptually almost done. What
> needs to be done now is fleshing out a bunch of details here and there.
> I'm sending it early so that I can collect some more feedback.
> 
> So the patchset is ontop of 2.6.36 + Steven's trace_cmd restructuring
> set from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/perf/parse-events
> 
> I'm adding his patches too here, for completeness (although they need
> some more work).

I tried to apply your patches here, but they didn't apply. i suspect that Steven
added some patches there at the meantime, as two patches on your series are already 
on his tree. IMO, the better would be if you could create a temporary tree or branch
to allow us to better view it.

> I've also cherry-picked the bunch of EDAC's MCE injection stuff for
> testing.
> 
> So, in the end of the day, if you do
> 
> echo 0x9c00410000010016 > /sys/devices/system/edac/mce/status
> 
> (0x9c.. is the MCE signature of a data cache L2 TLB multimatch, for
> example)

This example looks quite ugly to me. I doubt anyone without a datasheet and after a
very careful inspection would know what 0x9c00410000010016 magic number means. I
suspect that writing a wrong magic number will also produce a completely undesired
result. So, the better it to keep the MCE code internally to the driver.

Also, writing a magic number to a node named as "status" seems weird to me.

IMO, instead, it should be something like:

echo 1 >/sys/devices/system/edac/mce/error_inject

> 
> echo 0 > /sys/devices/system/edac/mce/bank
> 
> (0 means bank 0, i.e. data cache errors)
> 
> after having loaded the mce_amd_inj injection testing module, the RAS
> daemon get's the status signature in userspace:
> 
> ...
> DBG main: Read some mmapped data
> DBG main: MCE status: 0x9c00410000010016
> 
> All of the remaining fields can be postprocessed in arbitrary manner
> after that. The MCE decoding in the kernel can then be simplified by
> sharing it with the daemon, if needed. But that's another story.
> 
