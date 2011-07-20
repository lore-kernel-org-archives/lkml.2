Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1GTRyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:54:11 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:47316 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899Ab1GTRyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:54:09 -0400
X-AuditID: 12074424-b7b0fae000000a08-da-4e27164b1d88
Message-ID: <4E27163A.6090102@mit.edu>
Date: Wed, 20 Jul 2011 13:54:02 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] um: Implement a x86_64 vDSO
References: <1310994456-14142-1-git-send-email-richard@nod.at> <1310994456-14142-3-git-send-email-richard@nod.at>
In-Reply-To: <1310994456-14142-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsUixCmqrOstpu5nsHOGhMXlXXPYLCbvfMNo
	Mat3CosDs8fuBZ+ZPG7OK/T4vEkugDmKyyYlNSezLLVI3y6BK6Nx7yWWgt1cFW/fbmBtYFzO
	0cXIySEhYCJx+vJnVghbTOLCvfVsXYxcHEIC+xglnp0+wgiSEBLYwCjRdzgTInGBSWLy7k8s
	IAleATWJrTe+gRWxCKhKdE8+CTaJTUBFomPpA6YuRg4OUYFKiTmHLCDKBSVOznwC1ioioC7x
	7uVUNhCbWcBX4s/7y2BjhIEOOrW4jwVib6HEmzUXmEBsTgF7iXkru8BGMgtYS3zbXQTRKi+x
	/e0c5gmMgrOQbJiFUDULSdUCRuZVjLIpuVW6uYmZOcWpybrFyYl5ealFuuZ6uZkleqkppZsY
	QaHM7qKyg7H5kNIhRgEORiUeXkc+dT8h1sSy4srcQ4ySHExKorwyIkAhvqT8lMqMxOKM+KLS
	nNTiQ4wSHMxKIryK/9T8hHhTEiurUovyYVLSHCxK4ryl3v99hQTSE0tSs1NTC1KLYLIyHBxK
	Erx9okBDBYtS01Mr0jJzShDSTBycIMN5gIargdTwFhck5hZnpkPkTzEqSonzLgBJCIAkMkrz
	4HphqeYVozjQK8K8i0CqeIBpCq77FdBgJqDBLeqqIINLEhFSUg2MYh/m6Uh3nPKYEesytdH/
	VPYKmxOTdA9vuKj3myewSGpFUoCV/+rfBz5cmpNyg7s+KnFl/JorLZeez5X03ssjPLPT//6b
	PXf+CQX7s22+rr4tmq8z8vqCZwfnfrx8zef845JIBiXOUrksrdubbpueZN9xYYvrxoMrqudf
	94x9pcew4e7lVXM2/FdiKc5INNRiLipOBAAf/MwmEAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2011 09:07 AM, Richard Weinberger wrote:
> Until now UML had no x86_64 vDSO.
> So glibc always used the vsyscall page for gettimeday()
> and friends.
> Calls to gettimeday() returned falsely the host time and
> confused some programs.
>
> This patch adds a vDSO which turns all __vdso_* calls into
> a system call so that UML can trap them.
>
> As glibc still uses the vsyscall page for static binaries this
> patch improves the situation only for dynamic binaries.
>
> Signed-off-by: Richard Weinberger<richard@nod.at>

> +	asm("syscall" : "=a" (ret) :
> +		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
> +

The x86-64 ABI and glibc think that rcx, and r11 are clobbered.  glibc 
also thinks that cc is clobbered.  I personally think that rdx and 
r8-r15 ought to be clobbered under the principle that syscall should 
look like a function call.

It's hard to imagine this causing a problem in a function this trivial, 
though.

This applies to the other two syscall instructions as well.

--Andy

P.S.  If you really care, with the changes in tip/x86/vdso, it ought to 
be possible for UML to trap vsyscalls as well.  This would need a change 
to do_emulate_vsyscall to honor TIF_SYSCALL_EMU with intelligent 
semantics.  I know nothing about ptrace, so I'm not volunteering :)
