Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab1LGTk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:40:27 -0500
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:58885 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758226Ab1LGTk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:40:26 -0500
X-AuditID: 12074422-b7ff56d00000092f-14-4edfc1295d47
Message-ID: <4EDFC123.6070003@mit.edu>
Date: Wed, 07 Dec 2011 11:40:19 -0800
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Colin Walters <walters@verbum.org>
CC: LKML <linux-kernel@vger.kernel.org>, morgan@kernel.org, serue@us.ibm.com,
        dhowells@redhat.com, kzak@redhat.com
Subject: Re: chroot(2) and bind mounts as non-root
References: <1323280461.10724.13.camel@lenny>
In-Reply-To: <1323280461.10724.13.camel@lenny>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsUixCmqrat58L6fwbS72hbvmn6zWCxdsoPN
	4vKuOWwWLxcUWrxZcpPV4nzfFDYHNo9NqzrZPN7vu8rmce5aH7NH56crLB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZWw+eZSloIevYufkdWwNjPO4uxg5OSQETCSO7H3NDmGLSVy4t56ti5GLQ0hg
	H6PE9+cfWUESQgLrGSWe7meFSDxnkrj29hILSIJXQE2ipfcQmM0ioCoxddlTsElsAioSHUsf
	MIHYogJBEgu3dTFC1AtKnJz5BKxeBKj33KIJzCA2s0C1xINb58CWCQsYSTQ1r4ZarCvRe/4R
	2ExOAT2JzbNmA/VyANWrS6yfJwTRKi+x/e0c5gmMgrOQbJiFUDULSdUCRuZVjLIpuVW6uYmZ
	OcWpybrFyYl5ealFuqZ6uZkleqkppZsYQeHP7qK0g/HnQaVDjAIcjEo8vD9W3/cTYk0sK67M
	PcQoycGkJMrbeAAoxJeUn1KZkVicEV9UmpNafIhRgoNZSYT3yyygHG9KYmVValE+TEqag0VJ
	nJdrp4OfkEB6YklqdmpqQWoRTFaGg0NJgld9M1CjYFFqempFWmZOCUKaiYMTZDgP0PBSkMW8
	xQWJucWZ6RD5U4yKUuK8aiAJAZBERmkeXC8sPb1iFAd6RZhXCmQFDzC1wXW/AhrMBDSYL+ou
	yOCSRISUVANjz3c2joPmt/y4gio3rJx4f7LD5MZ/p1f++Xu8kUmBc+4J991Pr311t/8YVsPM
	NH+PH5eBirvjpy1c/ySb6k2Kns900vA1eyu1/vpW/RvXet8f3fL8wye1310lackcGvtu7OLM
	cNuavuq42Wldx1lVG04InYoq1z6mmlJR2hYuV3GtUz7r3P8oJZbijERDLeai4kQAQTESbSoD
	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 09:54 AM, Colin Walters wrote:
> Hi,
> 
> (TL;DR version: Please audit the attached setuid program)
> 
> I've recently been doing some work in software compilation, and it'd be
> really handy if I could call chroot(2) as a non-root user.  The reason
> to chroot is to help avoid "host contamination" - I can set up a build
> root and then chroot in.  The reason to do it as non-root is, well,
> requiring root to build software sucks for multiple obvious reasons.
> 
> (Now you can do LD_PRELOAD hacks to talk to a daemon like
> https://github.com/wrpseudo/pseudo does, but really - too gross and too
> slow).
> 
> The historical reason one can't call chroot(2) as non-root is because of
> setuid binaries (hard link a setuid binary into chroot of your choice
> with trojaned libc.so).  But it turns out a while back this commit:
> 
> commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
> Author: Andrew G. Morgan <morgan@kernel.org>
> Date:   Mon Apr 28 02:13:40 2008 -0700
> 
>     capabilities: implement per-process securebits
> 
> Added *exactly* what we need.  We just call:
> 
> prctl (PR_SET_SECUREBITS, SECBIT_NOROOT | SECBIT_NOROOT_LOCKED);
> 
> A setuid program to call both this and chroot(2) is *almost* good enough
> for my use case - but it's a little hard to run most build software
> without say /dev/null, /dev/urandom and /proc.
> 
> The other key thing Linux recently gained is CLONE_NEWNS - with this
> (and also SECBIT_NOROOT), we can allow users to make bind mounts to
> their heart's content, which frankly is just cool.  Bind mounts are a
> really neat VFS feature.

I will personally always be nervous until something like this happens:

http://thread.gmane.org/gmane.linux.kernel.lsm/10659

execve() is IMO scary.

--Andy
