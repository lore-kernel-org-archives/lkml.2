Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1KUAOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 19:14:05 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52489 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1KUAOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 19:14:02 -0500
Date: Mon, 21 Nov 2011 10:43:13 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        linux-arch@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: Cross Memory Attach v3
Message-ID: <20111121104313.63c7f796@cyeoh-System-Product-Name>
In-Reply-To: <CAMuHMdWAhn7M8o0qY4pz3W1tyyKEcNY_YQL_6JuAPCcjL5vS1A@mail.gmail.com>
References: <20110719003537.16b189ae@lilo>
	<CAMuHMdWAhn7M8o0qY4pz3W1tyyKEcNY_YQL_6JuAPCcjL5vS1A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 11112014-6102-0000-0000-000000346C6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sun, 20 Nov 2011 11:16:17 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Mon, Jul 18, 2011 at 17:05, Christopher Yeoh <cyeoh@au1.ibm.com>
> wrote:
> > For arch maintainers there are some simple tests to be able to
> > quickly verify that the syscalls are working correctly here:
> 
> I'm wiring up these new syscalls on m68k.
> 
> > http://ozlabs.org/~cyeoh/cma/cma-test-20110718.tgz
> 
> The included README talks about:
> 
>     setup_process_readv_simple
>     setup_process_readv_iovec
>    setup_process_writev
> 
> while the actual test executables are called:
> 
>     setup_process_vm_readv_simple
>     setup_process_vm_readv_iovec
>     setup_process_vm_writev

Oops. Have fixed this and uploaded a new version

 http://ozlabs.org/~cyeoh/cma/cma-test-20111121.tgz

It also includes another minor change (see below)

> On m68k (ARAnyM), the first and third test succeed. The second one
> fails, though:
> 
> # Setting up target with num iovecs 10, test buffer size 100000
> Target process is setup
> Run the following to test:
> ./t_process_vm_readv_iovec 1574 10 0x800030b0 89 0x80003110 38302
> 0x8000c6b8 22423 0x80011e58 18864 0x80016810 583 0x80016a60 8054
> 0x800189e0 3417 0x80019740 368 0x800198b8 897 0x80019c40 7003
> 
> and in the other window:
> 
> # ./t_process_vm_readv_iovec 1574 10 0x800030b0 89 0x80003110 38302
> 0x8000c6b8 22423 0x80011e58 18864 0x80016810 583 0x80016a60 8054
> 0x800189e0 3417 0x80019740 368 0x800198b8 897 0x80019c40 7003
> copy_from_process failed: Invalid argument

That should say process_vm_readv instead of copy_from_process. The
error message is fixed in the just updated test.

> error code: 29
> #
> 
> Any suggestions?
> 

Given that the first and third tests succeed, I think the problem is
with the iovec parameters. The -EINVAL is most likely coming from
rw_copy_check_uvector. Any chance that something bad is
happening to lvec/liovcnt or rvec/riovcnt in the wireup? 

The iovecs are checked in process_vm_rw before the core of the
process_vm_readv/writev code is called so should be easy to confirm if
this is the problem.

The other couple of places where it could possibly come from is that
for some reason the flags parameter ends up being non zero or when
looking up the task the mm is NULL. But given that the first and second
tests succeed I think its unlikely that either of these is the cause.

Regards,

Chris
-- 
cyeoh@au.ibm.com

