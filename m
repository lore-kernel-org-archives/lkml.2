Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab2GEO0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:26:54 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:42561 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756046Ab2GEO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:26:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FPDeTZ0VM1miSxz5eWlTK1OrN7rEsgeuXFvLnFE53rmsXNT
 OOu68C_n0LrVoJ9Z8MgLVE_LLbEmhPyGEm5P6UszcLPkAXCiz8xVSDL3zQA0
 1tx3y4vdxjzrI1rPx4mK72uMv4qW93WzTH0wriIZRIx_kb5RC71nUyoYl4my
 KTtRV7AZ9k0.2m7x4DcsAa8VI_TyFk.OCU9J9cmlhOBipLHY0z0cxTTGbe7f
 gYtLT5qeG24iRXUtHDgzXP8aE.UiaxH28X4fetDxk_RwGISZ_Nw4hpjf3GYp
 1Y9FEGuCiRHJq_q3Im1UpG_VVpyvpsgGr5dPwYyHq5TWymTUyja2fKLAipdA
 Qe9T1sn3BtsIzixudtAC1pIr6mwWC74eYYM9Wbh_..BSV0U_if1pcBYB8L79
 h3YCxLnC0YeeMfNUUo2RRrBJh2bh6ffhtI9uX
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 5 Jul 2012 09:26:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] slub: release a lock if freeing object with a lock
 is failed in __slab_free()
In-Reply-To: <1340389359-2407-3-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207050924330.4138@router.home>
References: <yes> <1340389359-2407-1-git-send-email-js1304@gmail.com> <1340389359-2407-3-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2012, Joonsoo Kim wrote:

> In some case of __slab_free(), we need a lock for manipulating partial list.
> If freeing object with a lock is failed, a lock doesn't needed anymore
> for some reasons.
>
> Case 1. prior is NULL, kmem_cache_debug(s) is true
>
> In this case, another free is occured before our free is succeed.
> When slab is full(prior is NULL), only possible operation is slab_free().
> So in this case, we guess another free is occured.
> It may make a slab frozen, so lock is not needed anymore.

A free cannot freeze the slab without taking the lock. The taken lock
makes sure that the thread that first enters slab_free() will be able to
hold back the thread that wants to freeze the slab.

> Case 2. inuse is NULL
>
> In this case, acquire_slab() is occured before out free is succeed.
> We have a last object for slab, so other operation for this slab is
> not possible except acquire_slab().
> Acquire_slab() makes a slab frozen, so lock is not needed anymore.

acquire_slab() also requires lock acquisition and would be held of by
slab_free holding the lock.

> This also make logic somehow simple that 'was_frozen with a lock' case
> is never occured. Remove it.

That is actually interesting and would be a good optimization.

