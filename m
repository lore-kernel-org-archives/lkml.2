Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1GTNzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:55:14 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:57730 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437Ab1GTNzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:55:13 -0400
X-AuditID: 1209190c-b7bdeae000000a26-a6-4e26ddd4d31d
Message-ID: <4E26DE3B.5090602@mit.edu>
Date: Wed, 20 Jul 2011 09:55:07 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: MK <mk@cognitivedissonance.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: AVX "Sandy Bridge" hardware issue?
References: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
In-Reply-To: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsUixG6nrnvlrpqfwZVOG4vLu+awWVxcNIPZ
	gcljZ+ttRo/Pm+QCmKK4bFJSczLLUov07RK4MhqPdDAX9IpV3N2+ma2B8YZgFyMnh4SAicTh
	nx9ZIWwxiQv31rN1MXJxCAnsY5TYu+gnI4SzgVHi0OeNUM5bJonps+aygLTwCqhJTLvVBGaz
	CKhK/F9+FMxmE1CR6Fj6gAnEFhUIkrj/uwGqXlDi5MwnYLaIgJLE6q3PwVYzCyhIdD2bxghi
	CwvoS7xe2w4WFxKwl5j2sJENxOYUcJC42LIZaCYHUL21xLfdRRCt8hLb385hnsAoOAvJhlkI
	VbOQVC1gZF7FKJuSW6Wbm5iZU5yarFucnJiXl1qka6iXm1mil5pSuokRFLyckjw7GN8cVDrE
	KMDBqMTDy7lR1U+INbGsuDL3EKMkB5OSKO/7O2p+QnxJ+SmVGYnFGfFFpTmpxYcYJTiYlUR4
	Ww4B5XhTEiurUovyYVLSHCxK4rzl3v99hQTSE0tSs1NTC1KLYLIyHBxKErzLgFEqJFiUmp5a
	kZaZU4KQZuLgBBnOAzT8Jshi3uKCxNzizHSI/ClGRSlx3gqQZgGQREZpHlwvLLm8YhQHekWY
	dyJIFQ8wMcF1vwIazARytboqyOCSRISUVAMjq7TH6py/PqKntx5euNrzXL76cWueU22ua994
	/W6saeqxX6639ezinkuvdl6yu+grKh4k18D+/ZbLClvO8MuHtfian3wyDOCew72mLDVJuvdN
	w4wAveNvz/IqWMtIhb478f2b9YVFFl3LJITO8m5/zT0v13P1Ip0cN39GoYbMEuWdVwT97SqV
	WIozEg21mIuKEwFhNqoyCQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 04:16 PM, MK wrote:
> Hi gang! I'd forgotten how busy this list is, I hope someone can help
> me out.
>
> I have a small VPS slice, run under openVZ, that I use for testing and
> personal projects.  Recently, the provider migrated to new Xeon "Sandy
> Bridge" processors, which according to wikipedia are the first and
> thus far only commercially available processors using AVX.
>
> After the migration, I had a number of apache mod_perl applications
> break due to SIGILL.   Reproducible test case:
>
> use Apache2::Const qw(SERVER_ERROR)
>
> sub handler {
>       return SERVER_ERROR;
> };
>
> Apache2::Const is the indirect culprit here; if I remove it and just
> return 500 the module works.  Note that this is not a perl error. A
> backtrace from running apache under gdb, triggering the issue, is here:
>
> http://pastebin.com/16SrEzHM
>
> I posted this to the mod_perl list and someone pointed me to a
> backtrace identical in its final contexts, from a glibc bug
> reported last year:
>
> http://sourceware.org/bugzilla/show_bug.cgi?format=multiple&id=12113
>
> Which involves AVX hardware.  The VPS provider has provided me with a
> bare Fedora 14 slice for debugging this issue, and the "small
> reproducer" available from the above bug report, verified by Ulrich
> Drepper, does reproduce the issue.
>
> So I filed a glibc bug with fedora to that effect:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=720176
>
> In which Andreas Schwab points out (rightly or wrongly) that according
> to the /proc/cpuinfo from the slice, the processor actually does not
> support AVX.  However,  the "model name", "Intel(R) Xeon(R) CPU
> E31230", is according to this a Sandy Bridge processor with AVX:
>
> http://en.wikipedia.org/wiki/Sandy_Bridge#Server_processors
>
> And while I do not have access to the hardware, the provider is very
> unequivocal about the fact that these are Sandy Bridges, which
> apparently include AVX.
>
> So I am looking for a next step to take in debugging this.  The kernel
> used on the slice (nb, openVZ does not allow for rolling your own) is
> 2.6.32 built with gcc 4.1.2.  I think this may be prior to AVX support
> in the kernel and gcc, but the glibc is 2.13, which apparently includes
> it.
>
> Does anyone have any idea why I would get this identical backtrace, and
> a failed reproducer test, on hardware which supposedly supports AVX
> (but not according to the kernel in /proc/cpuinfo)?

I was bored and read the manual.  It looks like glibc is buggy: it 
checks whether the CPU supports AVX but not whether the OS enables AVX.

http://sourceware.org/bugzilla/show_bug.cgi?id=13007

That being said, you should still bug your provider for a better kernel. 
  AVX is useful and should be enabled.

--Andy
