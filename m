Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab2GIOBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:01:17 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:37131 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753266Ab2GIOBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:01:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KitXAr8VM1lRCEjifQjgH_k4hYms.gXZ846c9h6517EEn25
 fifxjNCFH1ySfVN6vXyWuvmXtKvyeLZ1m70QenN0ZXQCjF7sV3FquJ7nhmjc
 GsGmIYsa_g8mtlJVKd94GtrhVYxspVzZCX0YGSgzP9uR58dDGmHbtnrKFzmy
 YGh93o6eqNGcLLsbv8q22joDA7YwyB48XMTfQtO0qpuTaurnb1q7yYNLScF2
 QvAwqmmzvFnEAo.O1aASTH5P.x4_SMU2IT99yZEQ9aieQqHEQFpRZFGk7f7L
 tkdFpsf8gmvSYJPcYC1G2l2QfwhchKGDq_SiS5D0WR4s5bdZy77ddWQj1ugt
 vPEZwuVfQLRUPBPwrxnVn_O2RFLgpwDko17DgCnhdRzwNewXgtnksUZR571Z
 OC9mSaEMbwN4yOP9oxdmsVAG6JXSfRfJ1tE6.
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 9 Jul 2012 09:01:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH SLAB 1/2 v3] duplicate the cache name in SLUB's saved_alias
 list, SLAB, and SLOB
In-Reply-To: <1341801721.2439.29.camel@ThinkPad-T420>
Message-ID: <alpine.DEB.2.00.1207090859420.27737@router.home>
References: <1341561286.24895.9.camel@ThinkPad-T420> <alpine.DEB.2.00.1207060855320.26441@router.home> <1341801721.2439.29.camel@ThinkPad-T420>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I was pointed by Glauber to the slab common code patches. I need some
> more time to read the patches. Now I think the slab/slot changes in this
> v3 are not needed, and can be ignored.

That may take some kernel cycles. You have a current issue here that needs
to be fixed.

> >  	down_write(&slub_lock);
> > -	s = find_mergeable(size, align, flags, name, ctor);
> > +	s = find_mergeable(size, align, flags, n, ctor);
> >  	if (s) {
> >  		s->refcount++;
> >  		/*
>
> 		......
> 		up_write(&slub_lock);
> 		return s;
> 	}
>
> Here, the function returns without name string n be kfreed.

That is intentional since the string n is still referenced by the entry
that sysfs_slab_alias has created.

> But we couldn't kfree n here, because in sysfs_slab_alias(), if
> (slab_state < SYS_FS), the name need to be kept valid until
> slab_sysfs_init() is finished adding the entry into sysfs.

Right that is why it is not freed and that is what fixes the issue you
see.
