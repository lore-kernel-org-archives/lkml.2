Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab2EIOF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:05:59 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:48758 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758249Ab2EIOF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:05:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ocLs_VMVM1nxasFymcOoI2giHuAkNoNR7yowKJ2Z3xet5bo
 cusMuWE.cKc0RSi7dOxhkU_el3hbP4L6FJOnfgNlGyUINpl6AEB0s8Npv5GY
 RkjR4aCLDHSS3FCIKk3VvnxqxFlTk7yFpA4q6JJ9XOymLTZiOsln92RVdjQh
 0xkXCmk7aptfXa4KJMW8IOjxHeCOKjDOwfBD7d6wlZse5H4azVGuZKFj0xuD
 yNa6O_1WaQt8n4GMOhd.EpDENmPSQGyQeROhDdpmZzIxicFZSwkTtD2kr.3C
 MbP89rKxxSZhlUzjIGzKSdVoIDXEsruoOwzpcdTXsZqAKxwB0j8h6tdK6wDx
 MIx7RaGo.qZbJICFU6dYOqub1jeHbbMWKb8wX6CgejrOIICCfpJpVe7Y3pMC
 yd_qNZ2gBjs7MoiFF_8lUSj5bpAanCF_K_Jlo
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 09:05:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: lockdep reports about recursive locking in kmemleak
In-Reply-To: <CAOJsxLFR0uqxJRysz+r5ojqPe0A4q14LeOuinSBPrNKbYuAAxw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205090904110.8171@router.home>
References: <4F9A835C.2020801@openvz.org> <20120430110420.GL10632@arm.com> <CAOJsxLFR0uqxJRysz+r5ojqPe0A4q14LeOuinSBPrNKbYuAAxw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Pekka Enberg wrote:

> > I'm not sure what the right fix is (cc'ing Christoph for the slab.c
> > code). The lockdep warning is not in kmemleak, it just happens that
> > cache_flusharray() (holding an l3->list_lock) triggers a new allocation
> > via debug_object_activate() and kmemleak also tries to allocate its
> > metadata, causing a cache_alloc_refill() call which acquires a
> > different l3->list_lock, hence the lockdep warning.
>
> How do we know it's always a different nodelist ("l3")?

The second l3 is from a cache that makes no use of "off-slab" secondary
slabs otherwise we would have a bad case of recursion.

If you mark the locks of caches with off-slab features differently from
the simple ones then we should be fine.
