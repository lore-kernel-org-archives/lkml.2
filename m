Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1EYOZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:25:17 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:24986 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541Ab1EYOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:25:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: pBzR.qAVM1kE8B2tfPX3RFGpZSWzjZJUBD5dV_4OeVSMb1C
 ObKOlhL4hTUWEeQ0epECdsC0_GyWKGqxCFLQX6QxVHr_rcry1_G_LdoQhfkB
 mnZse4DK1a3ip5tO642Yc1wjCWr3ULilWvRoxCCUE_iiLt7qRhjDvztAC8s3
 EPNtvriAPOBh3wwT1JHsYB2ElUbBLWIMTyX3g7JSa_7nRFZJz0NW4eb0ezZI
 6vP_DThBnGUAS8JOhVoZh9zsLJDIAL9aONkiIWct4tBeIdcibjCmdsc28Y.j
 L_.3jGtBq8RpaeRu3R7Gn6MXXGVq_CgwdGF0Mii604ScUOAmNk3IGg_wwlTG
 065bYdR422deUttb7obtdSqDN
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 May 2011 09:25:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: James Morris <jmorris@namei.org>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
In-Reply-To: <BANLkTik=H=1+oqQ9_5ZZaHpFn8_9x5V-nQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105250921560.23309@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org> <BANLkTik=H=1+oqQ9_5ZZaHpFn8_9x5V-nQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Linus Torvalds wrote:

> Look at __slab_alloc: we have:
>
>
>         page = c->page;
>         if (!page)
>                 goto new_slab;
>
>         slab_lock(page);
>         if (unlikely(!node_match(c, node)))
>                 goto another_slab;
>
> and let's assume we have two users racing on that "c->page". The
> "slab_lock()" is going to work for one of them, right?

There cannot be two users racing through this code segment since we have
interrupts disabled and c is pointing to a per cpu structure. c->page
points to a page that can only be allocated from from the current
processor (from the freelist in c->freelist) but it can be freed to from
multiple cpus (via the page->freelist). The code that you are discussing
is copying the freed objects from the page->freelist to the per cpu
freelist and it needs to lock out the slab_free path to do that.


