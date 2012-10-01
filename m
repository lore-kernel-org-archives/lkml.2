Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2JAVqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:46:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44472 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2JAVqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:46:01 -0400
Date: Mon, 1 Oct 2012 23:45:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Shantanu Gupta <shans95g@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: xchg in fastpath for mutex unlock [mutex-xchg.h]
Message-ID: <20121001214557.GA19126@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Shantanu Gupta <shans95g@gmail.com>, linux-kernel@vger.kernel.org
References: <CAPDArR+9Kd+Rzgxj9FgQR0NCayZskXkq4bg3U-GRpCKFP5uC+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPDArR+9Kd+Rzgxj9FgQR0NCayZskXkq4bg3U-GRpCKFP5uC+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 04:18:41PM +0530, Shantanu Gupta wrote:
> Hello,
> 
> I am currently studying mutex(es) and was referring to linux sources
> for it's implementation. However I noticed one shortcoming, in
> "/include/asm-generic/mutex-xchg.h" of the master branch inside
> __mutex_fastpath_trylock, Why doesn't the kernel use a cmpxchg instead
> of dirtying the value with xchg ?
> 
> (The only thing that came to my mind was that x86_x64 implementation
> mentioned that all x86_x64 cpu(s) have cmpxchg leading me to
> assumption that certain archs can have xchg but not cmpxchg, so is it
> this way just to work with architectures without a cmpxchg but with
> xchg ?)

Yes.

Btw, 'git annotate' helps with such questions-to-self sometimes. Because
if you do

$ git annotate include/asm-generic/mutex-xchg.h

you can find the following patch adding __mutex_fastpath_trylock:

commit 620a6fd185c084aa617c411f711533f01ea673c9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jan 9 15:59:17 2006 -0800

    [PATCH] mutex subsystem, add asm-generic/mutex-[dec|xchg|null].h implementations

    Add three (generic) mutex fastpath implementations.

    The mutex-xchg.h implementation is atomic_xchg() based, and should
    work fine on every architecture.

    The mutex-dec.h implementation is atomic_dec_return() based - this
    one too should work on every architecture, but might not perform the
    most optimally on architectures that have no atomic-dec/inc instructions.

    The mutex-null.h implementation forces all calls into the slowpath. This
    is used for mutex debugging, but it can also be used on platforms that do
    not want (or need) a fastpath at all.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Arjan van de Ven <arjan@infradead.org>

HTH.

-- 
Regards/Gruss,
    Boris.
