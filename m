Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2JWVix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:38:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57157 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab2JWViv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:38:51 -0400
Date: Tue, 23 Oct 2012 23:38:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-ID: <20121023213845.GA21115@aftab.osrc.amd.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
 <20121023121005.ed33061a.akpm@linux-foundation.org>
 <20121023202612.GA20526@aftab.osrc.amd.com>
 <20121023133709.21e9cb72.akpm@linux-foundation.org>
 <20121023204926.GA20787@aftab.osrc.amd.com>
 <20121023140939.28ed0df4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121023140939.28ed0df4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 02:09:39PM -0700, Andrew Morton wrote:
> On Tue, 23 Oct 2012 22:49:26 +0200
> Borislav Petkov <bp@amd64.org> wrote:
> 
> > Now you only need to give me a proper patch with your S-O-B and we're
> > ready to go :).
> 
> who, me, what?!?!  Sounds stressful.

Yeah, this is to show you how we all feel when we're on the sending end
of patches :-).

> 
> umm, OK here we go.
> 
> What I don't understand is the effects of the bug.  If the present code
> can indeed start using the n+1th element of the array then it's writing
> random garbage into the hardware.  If this can ever happen then I
> suspect that yes, a cc:stable is needed?

Yes, cc:stable is needed.

The code has a very subtle bug because I should've robustified it from
the get-go instead of fiddling with it.

Basically, this is what happens:

If you supply new_bw < 761, i.e. so that the last element matches, *and*
you have a minimum scrubrate set to != 0x0 (due to unsupported scrubrate
settings on some families) the first continue in the loop with i being
22 (last array element) terminates the loop after incrementing i one
last time.

Thus, it doesn't let us break out of it in the next statement where
the new_bw will match and we'll be able to exit the loop without it
incrementing i one last time and thus get us out of bounds.

So yes, your fix is correct, I'll test it tomorrow just in case and
will sit down and rewrite this loop because it pisses me off to see how
stupidly fragile it is.

And I see you'll carry this patch so I won't send it to Linus next merge
window so thanks for this!

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/edac/amd64_edac.c:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]
> 
> If none of the elements in scrubrates[] matches, this loop will cause
> __amd64_set_scrub_rate() to incorrectly use the n+1th element.
> 
> As the function is designed to use the final scrubrates[] element in the
> case of no match, we can fix this bug by simply terminating the array
> search at the n-1th element.
> 
> Reported-by: Denis Kirjanov <kirjanov@gmail.com>
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: stable@vger.kernel.org

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ … ]

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
