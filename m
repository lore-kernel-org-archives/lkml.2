Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1EYFWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:22:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48447 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab1EYFWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y0GzTOiN002MDa8nOhp34DDSiLGatsCtN0PumR+WAQGh8l8EepdAkXftZyizVdzuqT
         MGSCdgs1di3R+fV6K+G52K4fok3evf5H2GHIh3sa+lV6nNXpaW6f8RLfwY8C9gNulU6j
         oXRwXUehGutz8yBYL3+50z391jHLDrVBpdVjY=
MIME-Version: 1.0
In-Reply-To: <BANLkTik=H=1+oqQ9_5ZZaHpFn8_9x5V-nQ@mail.gmail.com>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
	<BANLkTik=H=1+oqQ9_5ZZaHpFn8_9x5V-nQ@mail.gmail.com>
Date: Wed, 25 May 2011 08:22:21 +0300
X-Google-Sender-Auth: l7v5oOboa86CGkNAiasZNuUfxbs
Message-ID: <BANLkTim1Zhrq+cmTrydt8k3zgVUjDvGp2g@mail.gmail.com>
Subject: Re: SLUB regression in current Linus
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 2:03 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 24, 2011 at 4:52 AM, James Morris <jmorris@namei.org> wrote:
>>
>> Reverting the patch appears to fix the hang for me, although I'm not sure
>> what the actual problem is.
>>
>> This is on a quad-core Opteron (1352). Let me know if you need any further
>> info.
>
> That whole "deactivate_slab()" + "c->page = NULL" that that patch does
> looks bogus.
>
> Look at __slab_alloc: we have:
>
>
>        page = c->page;
>        if (!page)
>                goto new_slab;
>
>        slab_lock(page);
>        if (unlikely(!node_match(c, node)))
>                goto another_slab;
>
> and let's assume we have two users racing on that "c->page". The
> "slab_lock()" is going to work for one of them, right?
>
> Ok, so the one it works for will then hit
>
>        if (kmem_cache_debug(s))
>                goto debug;
>
> and thus get to the new "deactivate_slab(s,c) + c->page = NULL" and
> then unlock the page.
>
> In the meantime, the one that wasn't able to lock the page will now go
> forward, but will not have "node_match()" any more, so it does that
> "goto another_slab".
>
> Which does "deactivate_slab(s,c)" again, and now c->page is NULL, so
> that totally breaks.
>
> What am I missing?
>
> That patch seems to be just broken piece-of-s%^!
>
> Christoph, Pekka, please tell me why I shouldn't immediately revert
> it. What am I missing?

It's safe to revert it, yes. Christoph? AFAICT Linus is correct here.
