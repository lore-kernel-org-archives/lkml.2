Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1KWQGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:06:30 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:36920 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752017Ab1KWQG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:06:29 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OBpATuIVM1mLOIjrSGZRm_Gkz9cwNXwLzhhoJa68OZLWMkq
 Pvpe21k4uCQp4vkWuNtjjrPZ5cPS581JUq5GwT_ArTiFOBXOr.lvDgqUOPQe
 OSjYfVW7sXA4I.ECw6XHzpBw4BXK2YXax89mmuq368ehQxdSPhYFyEor_Q9h
 s4iMQLifip3AGEZaoVPSxcnQnN8fFnjVj61y2wl4rsJJ6IbvfIS6bgkCH6uS
 D2Zu1rZL8PIqvfAPAcEqpdLRWugQbYC4AQPaJ_vPFYRfr9L.bR040KVkQOhQ
 CYlGmLjVty0PkQXt17jq0SCkj83yi7YzJo.GjlT2e7FQ7ULx7HMygt.s.J__
 sn3IK1bJqLRr94rR88SNbQZab0LXGHomZuoMeejwVsmzavA.HAWbscsh72Oy
 j0zkwPJ4JsY9bbGVqYoZY7A--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 23 Nov 2011 10:06:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Eric Dumazet <eric.dumazet@gmail.com>, "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, tj@kernel.org,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <20111123160353.GA1673@x4.trippels.de>
Message-ID: <alpine.DEB.2.00.1111231004490.17317@router.home>
References: <1321605837.30341.551.camel@debian> <20111118085436.GC1615@x4.trippels.de> <20111118120201.GA1642@x4.trippels.de> <1321836285.30341.554.camel@debian> <20111121080554.GB1625@x4.trippels.de> <20111121082445.GD1625@x4.trippels.de>
 <1321866988.2552.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121131531.GA1679@x4.trippels.de> <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121153621.GA1678@x4.trippels.de> <20111123160353.GA1673@x4.trippels.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Markus Trippelsdorf wrote:

> > FIX idr_layer_cache: Marking all objects used
>
> Yesterday I couldn't reproduce the issue at all. But today I've hit
> exactly the same spot again. (CCing the drm list)

Well this is looks like write after free.

> =============================================================================
> BUG idr_layer_cache: Poison overwritten
> -----------------------------------------------------------------------------
> Object ffff8802156487c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8802156487d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8802156487e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff8802156487f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff880215648800: 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ....kkkkkkkkkkkk
> Object ffff880215648810: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

And its an integer sized write of 0. If you look at the struct definition
and lookup the offset you should be able to locate the field that
was modified.
