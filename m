Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1AURJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:09:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1AURJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RoI+hNSExqWMsVxlo5ZAkIwBbrPUDFxxFd+ZSWlN+SuambMsoe0ZHfUbKr7/LXiEX9
         NDXcZotmGIeCiIng+4X5SJ5rNZn2ti41IIp2B8wOe2nH+Bbr/Tt6xHlyeTd5UlN7zIOl
         gdkcS2i4hl3FcLrNKMGnUTRfvZX48qghUP0bA=
Date: Fri, 21 Jan 2011 18:08:47 +0100
From: Tejun Heo <tj@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110121170847.GH2832@htj.dyndns.org>
References: <4D263C91.30709@zytor.com>
 <alpine.DEB.2.00.1101070907060.3014@router.home>
 <20110107180419.GB23082@Krystal>
 <alpine.DEB.2.00.1101071227450.3014@router.home>
 <20110108172453.GF13269@mtj.dyndns.org>
 <4D393636.4040607@cs.helsinki.fi>
 <20110121092649.GA2832@htj.dyndns.org>
 <4D39A6EB.70705@zytor.com>
 <20110121154831.GE2832@htj.dyndns.org>
 <20110121165425.GB11687@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121165425.GB11687@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 21, 2011 at 11:54:25AM -0500, Mathieu Desnoyers wrote:
> "The single large 128 bit scalar does not work. Having to define an
> additional structure it also a bit clumsy. I think its best to get
> another patchset out that also duplicates the first parameter and
> makes the percpu variable specs conform to the other this_cpu ops."
>
> I'm again probably missing something, but what is "clumsy" about
> defining a structure like the following to ensure proper alignment
> of the target pointer (instead of adding a runtime test) ?
> 
> struct cmpxchg_double {
> #if __BYTE_ORDER == __LITTLE_ENDIAN
>         unsigned long low, high;
> #else
>         unsigned long high, low;
> #endif
> } __attribute__((packed, aligned(2 * sizeof(unsigned long))));
>
> (note: packed here along with "aligned" does _not_ generate ugly
> bytewise read/write memory ops like "packed" alone. The use of
> "packed" is to let the compiler down-align the structure to the
> value requested, instead of uselessly aligning it on 32-byte if it
> chooses to.)

Yeah, good point.  :-)

> The prototype could then look like:
> 
> bool __this_cpu_generic_cmpxchg_double(pcp, oval_low, oval_high, nval_low, nval_high);
> 
> With:
>   struct cmpxchg_double *pcp
> 
> I think Christoph's point is that he wants to alias this with a pointer. Well,
> this can be done cleanly with:
> 
> union {
>         struct cmpxchg_double casdbl;
>         struct {
>                 void *ptr;
>                 unsigned long cpuid_tid;
>         } t;
> }
> 
> So by keeping distinct variables for the oval/nal arguments, we let
> the compiler use registers (instead of the mandatory stack use that
> would be required if we pass union or structures as oval/nval
> arguments), but we ensure proper alignment (and drop the unneeded
> second pointer, as well as the runtime pointer alignment checks) by
> passing one single pcp pointer of a fixed type with a known
> alignment.

Actually, we might be able to work around the stack usage regardless
of the passed type.  We should be able to decompose the structure or
ulonglong using macro and then pass the decomposed parameters to a
function if necessary.

Hmm, if we do ulonglong, we don't even need a separate interface and
can simply use cmpxchg().  If someone can come up with something which
uses ulonglong that way, it would be great; then, we wouldn't need to
worry about alignment either.  Am I missing something?

Thanks.

-- 
tejun
