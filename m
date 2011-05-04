Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1EDL1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:27:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44264 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1EDL1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=HO39J/9yVJxaf4HKkRCwagk7rxCDQKSdDObvTZ2Q+HDLvGxC+ajUzsfweAj4yriqHo
         MEM4jWgwn3wJhXaRKbYy34tbnoPsK5UDqdCnoSHr0NcszzqR1qFdmQVm6SPaVYSa2Crw
         XDkX0yLis00oY5eYOg2x0NjWGHxGYgRr0thkg=
Date: Wed, 4 May 2011 13:27:46 +0200
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504112746.GE8007@htj.dyndns.org>
References: <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 04, 2011 at 02:16:57PM +0300, Pekka Enberg wrote:
> On Wed, May 4, 2011 at 2:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 4 May 2011, Ingo Molnar wrote:
> > Well, it's pretty simple:
> >
> > CONFIG_X86_CMPXCHG64=y compiles this_cpu_generic_cmpxchg_double() into:
> >
> >    28f7:       89 f9                   mov    %edi,%ecx
> >    28f9:       8b 3e                   mov    (%esi),%edi
> >    28fb:       89 45 e4                mov    %eax,-0x1c(%ebp)
> >    28fe:       89 c3                   mov    %eax,%ebx
> >    2900:       8b 45 f0                mov    -0x10(%ebp),%eax
> >    2903:       64 0f c7 0f             cmpxchg8b %fs:(%edi)
> >    2907:       0f 94 c0                sete   %al
> >    290a:       84 c0                   test   %al,%al
> >    290c:       88 45 e4                mov    %al,-0x1c(%ebp)
> >    290f:       74 a4                   je     28b5 <kmem_cache_alloc+0x29>
> >
> > while CONFIG_X86_CMPXCHG64=n results in:
> >
> >    28b0:       8b 03                   mov    (%ebx),%eax
> >    28b2:       64 8b 30                mov    %fs:(%eax),%esi
> >    28b5:       39 d6                   cmp    %edx,%esi
> >    28b7:       75 d2                   jne    288b <kmem_cache_alloc+0x26>
> >    28b9:       64 8b 50 04             mov    %fs:0x4(%eax),%edx
> >    28bd:       39 ca                   cmp    %ecx,%edx
> >    28bf:       75 ca                   jne    288b <kmem_cache_alloc+0x26>
> >    28c1:       8b 4b 14                mov    0x14(%ebx),%ecx
> >    28c4:       8b 0c 0e                mov    (%esi,%ecx,1),%ecx
> >    28c7:       64 89 08                mov    %ecx,%fs:(%eax)
> >    28ca:       8b 03                   mov    (%ebx),%eax
> >    28cc:       42                      inc    %edx
> >    28cd:       64 89 50 04             mov    %edx,%fs:0x4(%eax)
> >
> > And that code runs with preemption enabled. So when the task gets
> > preempted _BEFORE_ it has actuallty written back the data, then the
> > race window is wide open.

Hmmm... if it's a race caused by preemtion enabled where it shouldn't
be, it's most likely the wrong type of this_cpu_cmpxchg_double() being
used in SLUB?  ie. __this_cpu_cmpxchg_double() where it should have
been this_cpu_cmpxchg_double()?  Christoph?

Thanks.

-- 
tejun
