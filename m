Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1JWJw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:52:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49883 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab1JWJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <20111023112140.37fd8b3d@xenia.leun.net>
References: <20111023112140.37fd8b3d@xenia.leun.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Oct 2011 12:52:06 +0300
X-Google-Sender-Auth: pRUdl2O-eCAbl4NCOhOmFoirULE
Message-ID: <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
Subject: Re: Bisected: Massive memory leak in dm-snapshot in 3.1 development introduced
To: Alasdair G Kergon <agk@redhat.com>
Cc: Michael Leun <ml@newton.leun.net>, LKML <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making sure that Alasdair sees this too (hopefully he picked up on it
from dm-devel, but best send things directly too)

Mikulas, Alasdair? I see the mempool_free() for the "master job", what
about everything else? Does the dm_kcopyd_prepare_callback() perhaps
need to do a

    job->master_job = job;

or similar?

                   Linus

On Sun, Oct 23, 2011 at 12:21 PM, Michael Leun <ml@newton.leun.net> wrote:
> Hi,
>
> How to reproduce:
>
> lvcreate -L30G -n testsnap vg1 # of course substitute VG as appropriate
> dd if=/dev/zero of=/dev/vg1/testsnap bs=2M # to make things clear
> lvcreate -L15G -s /dev/vg1/test -n testsnap
> dd if=/dev/zero of=/dev/vg1/testsnap bs=2M &
> watch free
>
> I noticed roughly 1GB memory vanishing from free / -/+ buffers/cache
> per 2GB copied.
>
> Bisecting yielded a6e50b409d3f9e0833e69c3c9cca822e8fa4adbb, reverting
> that from git master cures the memory leak
>
> --
> MfG,
>
> Michael Leun
>
>
