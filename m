Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab1KKPCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:02:13 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:33870 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752723Ab1KKPCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:02:12 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OAKoUdEVM1lu6LcbxjDIsqPPXBe9NDug7KL0bVAmCsJuivy
 bNp6Ef7aMo7VCW6U8RSlhFeGMgkjnSL00XDo3is4saKwFA6ovnyMaYyg4msb
 SU1z5dAoYvQi80Zj.2MRZqRYB98w5fF0ppXNTq9lHNBGhq_MsQMQBeBUOs9z
 BQMB6MeLhREjN1sqvUn5QmdyeVkqAXpXno9dUKncjUjkNdxaaisQNhfxAY_Y
 FTk81ChNAm4jXJu0_m2.mKBY8c2GDcKKMF5tD6lEORW2iALwFQbPqg4UPznu
 9Mnv_g7NYj1iNiGXLdU.Gx2NBh0EY.q51ZKCkCE3Ne8o6yuOYxw7oUoGd_Bg
 1ImfULFwYkcVEqmEqrlynx6ZuOdArHmGLHxKhJpg3U_RvGw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 Nov 2011 09:02:08 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Shaohua Li <shaohua.li@intel.com>
cc: Julie Sullivan <kernelmail.jms@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: INFO: possible recursive locking detected: get_partial_node()
 on 3.2-rc1
In-Reply-To: <1320980671.22361.252.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1111110857330.3557@router.home>
References: <20111109090556.GA5949@zhy>  <201111102335.06046.kernelmail.jms@gmail.com> <1320980671.22361.252.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011, Shaohua Li wrote:

> Looks this could be a real dead lock. we hold a lock to free a object,
> but the free need allocate a new object. if the new object and the freed
> object are from the same slab, there is a deadlock.

unfreeze partials is never called when going through get_partial_node()
so there is no deadlock AFAICT.

> discard_slab() doesn't need hold the lock if the slab is already removed
> from partial list. how about below patch, only compile tested.

In general I think it is good to move the call to discard_slab() out from
under the list_lock in unfreeze_partials(). Could you fold
discard_page_list into unfreeze_partials()? __flush_cpu_slab still calls
discard_page_list with disabled interrupts even after your patch.



