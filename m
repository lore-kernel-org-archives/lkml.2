Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2BPTik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:38:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2BPTii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:38:38 -0500
Message-ID: <4F3D5B35.4000606@redhat.com>
Date: Thu, 16 Feb 2012 21:38:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com> <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de> <4F3BB9DC.6040102@redhat.com> <3DC824A5-5D5A-4BCC-A0FB-1B459B7E362D@suse.de> <4F3D57E3.7020503@redhat.com> <810F6879-64A9-4FCF-9C22-00BCC945D6B0@suse.de>
In-Reply-To: <810F6879-64A9-4FCF-9C22-00BCC945D6B0@suse.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 09:34 PM, Alexander Graf wrote:
> On 16.02.2012, at 20:24, Avi Kivity wrote:
>
> > On 02/15/2012 04:08 PM, Alexander Graf wrote:
> >>> 
> >>> Well, the scatter/gather registers I proposed will give you just one
> >>> register or all of them.
> >> 
> >> One register is hardly any use. We either need all ways of a respective address to do a full fledged lookup or all of them. 
> > 
> > I should have said, just one register, or all of them, or anything in
> > between.
> > 
> >> By sharing the same data structures between qemu and kvm, we actually managed to reuse all of the tcg code for lookups, just like you do for x86.
> > 
> > Sharing the data structures is not need.  Simply synchronize them before
> > lookup, like we do for ordinary registers.
>
> Ordinary registers are a few bytes. We're talking of dozens of kbytes here.

A TLB way is a few dozen bytes, no?

> > 
> >> On x86 you also have shared memory for page tables, it's just guest visible, hence in guest memory. The concept is the same.
> > 
> > But cr3 isn't, and if we put it in shared memory, we'd have to VMREAD it
> > on every exit.  And you're risking the same thing if your hardware gets
> > cleverer.
>
> Yes, we do. When that day comes, we forget the CAP and do it another way. Which way we will find out by the time that day of more clever hardware comes :).

Or we try to be less clever unless we have a really compelling reason. 
qemu monitor and gdb support aren't compelling reasons to optimize.

> > 
> > It's too magical, fitting a random version of a random userspace
> > component.  Now you can't change this tcg code (and still keep the magic).
> > 
> > Some complexity is part of keeping software as separate components.
>
> Why? If another user space wants to use this, they can
>
> a) do the slow copy path
> or
> b) simply use our struct definitions
>
> The whole copy thing really only makes sense when you have existing code in user space that you don't want to touch, but easily add on KVM to it. If KVM is part of your whole design, then integrating things makes a lot more sense.

Yeah, I guess.

>
> > 
> >> There are essentially no if(kvm_enabled)'s in our MMU walking code, because the tables are just there. Makes everything a lot easier (without dragging down performance).
> > 
> > We have the same issue with registers.  There we call
> > cpu_synchronize_state() before every access.  No magic, but we get to
> > reuse the code just the same.
>
> Yes, and for those few bytes it's ok to do so - most of the time. On s390, even those get shared by now. And it makes sense to do so - if we synchronize it every time anyways, why not do so implicitly?
>

At least on x86, we synchronize only rarely.



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

