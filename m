Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0KENsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:48:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33905 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0KENst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:48:49 -0400
Date: Fri, 5 Nov 2010 14:46:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "acme@infradead.org" <acme@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/20] RAS daemon v3
Message-ID: <20101105134658.GA24828@aftab>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
 <4CD3F25A.6070609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD3F25A.6070609@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 08:02:34AM -0400, Mauro Carvalho Chehab wrote:
> I tried to apply your patches here, but they didn't apply. i suspect
> that Steven added some patches there at the meantime, as two patches
> on your series are already on his tree. IMO, the better would be if
> you could create a temporary tree or branch to allow us to better view
> it.

Sure:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ras-v3

> This example looks quite ugly to me. I doubt anyone without a
> datasheet and after a very careful inspection would know what
> 0x9c00410000010016 magic number means.

Right, this was only a hands-on example of what otherwise a script does.
I wanted to show what happens in detail.

> I suspect that writing a wrong magic number will also produce a
> completely undesired result.

That's not a problem since this is software-only injection. It actually
makes sense to be able to inject crap so that you can test the decoding
code:

[81953.494078] [Hardware Error]: MC5_STATUS: Uncorrected error, other errors lost: no, CPU context corrupt: yes, UECC Error
[81953.505714] [Hardware Error]: Corrupted FR MCE info?
[81953.505718] [Hardware Error]: Transaction: GEN (GEN), no timeout, Cache Level: L3/GEN, Participating Processor: GEN

> So, the better it to keep the MCE code
> internally to the driver.
> 
> Also, writing a magic number to a node named as "status" seems weird to me.
> 
> IMO, instead, it should be something like:
> 
> echo 1 >/sys/devices/system/edac/mce/error_inject

Well, this way you inject a random error. But you want to control the
error types which you inject and set not only one but a couple of the
MCi_ bank MSRs. In that manner, you can inject the address at which a
certain MCE happens and so on.

So, basically, the long term goal is to have a tool which could do all
that. Maybe something like this:

perf inject --mce --functional-unit DC --uncorrectable --pcc-corrupt --virtual-address 0xdeadbeef ...

or

perf inject --mce --functional-unit IC --random --correctable --ecc

(I have long options so that it's clear what we do - we can make them
shorter in the actual case.) But you get the idea. This way, you can
inject all kinds of stuff and also in a human-readable form.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
