Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2CLQ3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:29:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2CLQ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:29:10 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=9rqPhMEo_WsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=JBtdq7szB1vJRE_r3M8A:9 a=EtujWsRI_y9QW6Hzx2UA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331569747.25686.641.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/7] x86/jump labels: Use etiher 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 12 Mar 2012 12:29:07 -0400
In-Reply-To: <20120312161743.GB2607@redhat.com>
References: <20120308221730.807074710@goodmis.org>
	 <20120308222202.525768259@goodmis.org> <20120312161743.GB2607@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 12:17 -0400, Jason Baron wrote:
>  
> > By allowing the jump labels to be 2 bytes, it speeds up the
> > nops, not only 2 byte nops are faster than 5 byte nops, but also
> > because it saves on cache foot print.
> > 
> >    text    data     bss     dec     hex filename
> > 13403667 3666856 2998272 20068795 13239bb ../nobackup/mxtest/vmlinux-old
> > 13398536 3666856 2998272 20063664 13225b0 ../nobackup/mxtest/vmlinux-new
> > 
> > Converting the current v3.2 trace points saved 5,131 bytes.
> > As more places use jump labels, this will have a bigger savings.
> > 
> 
> Hi Steven,
> 
> Strange. I'm not seeing the text size savings with this patch, relative
> to the 'old' jump label compiled code. Is your comparison against jump
> labels disabled?

Note, the code went through several changes since I first pushed these.
I did not redo the size tests in my rebase.

> 
> Here's the size without your patch 'CONFIG_JUMP_LABEL' set:
> 
>    text    data     bss     dec     hex filename
> 10809465        1023976 1159168 12992609         c64061 vmlinux
> 
> And with your patches and 'CONFIG_JUMP_LABEL' set:
> 
>    text    data     bss     dec     hex filename
> 10812613        1023976 1163264 12999853         c65cad vmlinux

Interesting that your test had a 3k increase?? but the jump label code
increased by only 720bytes. This looks very fishy.  And yes, I did have
jump label enabled for my changes. I didn't change the config in the two
checks. IIRC, I did a localyesconfig so that I would get the updates of
the modules that would be used it my code, against a distro config.

> 
> So an increase in text of 3148. Which is not completely explained by the
> increase in arch/x86/kernel/jump_label.o:
> 
> without your patch 'CONFIG_JUMP_LABEL' set:
> 
>    text    data     bss     dec     hex filename
>     229       0       0     229      e5 arch/x86/kernel/jump_label.o
> 
> 
> with your patch 'CONFIG_JUMP_LABEL' set:
> 
>    text    data     bss     dec     hex filename
>     943       0       8     951     3b7 arch/x86/kernel/jump_label.o
> 
> So jump_label.o is 714 bytes larger, which is not enough to explain the
> 3148 byte increase.

Right this looks strange.

> 
> I'm using gcc (GCC) 4.6.2 20111027 (Red Hat 4.6.2-1).

I'm still using 4.6.0.

> 
> Can you please double check the savings.

I'll check again.

-- Steve


