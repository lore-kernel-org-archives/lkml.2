Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1HEQcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:32:15 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:22846 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751655Ab1HEQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:32:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: J3d8qWAVM1lm7v0B61mi9hDe3_YrwIC5Zxdk7gKF__NV9_6
 JN0MS0yj15gYeMez3g9MS8Kxmk0ZG7CXlOIvADkCwlyb61d9zdgEh_XM0YhF
 hS8hRXvZfm4velEV243t1Rm58h.OZitb3lBHvq4zFHAOUl9.Patw7fq_mFHG
 K2cK1JpPjqamVQafxz6Qme0OuToZpZB5bVlyeuEtn5on7hQM4go3DnT98B5s
 VpP48esrkJMDFE1_zeqAhriLtWdrba0Xewn4huRARTSj3VtBFkI7AVHKGtFL
 yF5Gfk7w0x.tdpLvhQtBtNVFljkLY5Ya.Cl4fAPbY5cVIdE.UeEGx.mfFF.W
 hEAAwuOaUewEbKJjFYLoqUff9qf9GjJxXA9pLhM9TzBOO5cTiGociXsek_JJ
 4aybRgh1Ri44fDC_Y1h21Kng3xxe1wfWJfycbwl0ot9Rm76jeh30tDPQ-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 5 Aug 2011 11:32:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108051131440.28580@router.home>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-904295241-1312561931=:28580"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-904295241-1312561931=:28580
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 5 Aug 2011, Pekka Enberg wrote:

> On Fri, Aug 5, 2011 at 11:46 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2011.08.04 at 21:00 -0400, Dave Jones wrote:
> >> Sometime in the last week, something was merged which causes my laptop
> >> to lock up occasionally. =A0I can trigger it most of the time just by
> >> doing a kernel build. When it gets to the final linking stage, it lock=
s up hard.
> >>
> >> I finally managed to coax something out of usb console to get the trac=
es below,
> >> which seem to implicate something in the block layer ?
> >>
> >> my root device is an lvm volume on an dmcrypt'd block dev, which might=
 be relevant,
> >> as I don't see this happening on other machines with simpler setups.
> >>
> >> I'm going to try bisecting, but it might take me a few days, because i=
t's
> >> such a pain in the ass to reproduce this reliably.
> >>
> >> [ 5913.233035] ------------[ cut here ]------------
> >> [ 5913.233097] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0=
x98()
> >> [ 5913.233101] Hardware name: Adamo 13
> >> [ 5913.233105] list_del corruption. prev->next should be ffffea000434f=
d20, but was ffffea0004199520
> >
> > See also: http://lkml.org/lkml/2011/8/3/37
>
> That's in networking so SLUB lockless patches are almost certainly the
> issue here. Is this with SLUB debugging enabled or not? Christoph, it
> like the partial lists are getting corrupted somehow.

This is occurring in __slab_free when we are freeing the last
object from a slab page that is on the partial list. It is not frozen so
it is not in use by a processor and thus deactivate_slab cannot be run
on it.

The logical race would be with acquire_slab() but both take the node lock
before doing anything with the lists.

Do you have CONFIG_DEBUG_VM on? If not please do so. This will check if
the frozen state is managed correctly.

---1463811839-904295241-1312561931=:28580--
