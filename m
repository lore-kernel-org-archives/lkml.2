Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1BVVAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:00:08 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43577 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1BVVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:00:01 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: does hibernate to disk try hard enough to free memory?
Date: Tue, 22 Feb 2011 21:59:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-tp42-rtime-00004-g9eb63ce; KDE/4.5.3; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1380842.Q2kA83GQZ3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201102222159.58546.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1380842.Q2kA83GQZ3
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi!

Since Radeon KMS I often have it that my ThinkPad T42 with 2 MiB of RAM is=
=20
not able to allocate memory for the hibernation image. Before KMS=20
hibernation only very rarely failed for that reason.

Often I run without compositing at all as I believe this might spare some=20
pages as well. But this doesn't always help.

It complains that to less pages could be freed. For example with kernel=20
2.6.37:

=46eb 16 00:15:00 shambhala kernel: PM: Creating hibernation image:
=46eb 16 00:15:00 shambhala kernel: PM: Need to copy 186577 pages
=46eb 16 00:15:00 shambhala kernel: PM: Normal pages needed: 114411 + 1024,=
=20
available pages: 112767
=46eb 16 00:15:00 shambhala kernel: PM: Not enough free memory
=46eb 16 00:15:00 shambhala kernel: PM: Error -12 creating hibernation image
=46eb 16 00:15:00 shambhala kernel: Extended CMOS year: 2000
=46eb 16 00:15:00 shambhala kernel: ACPI: Waking up from system sleep state=
=20
S4
=46eb 16 00:15:00 shambhala kernel: PM: early recover of devices complete=20
after 0.376 msecs

This was with:

martin@shambhala:~> cat /proc/version
Linux version 2.6.37-tp42-rtime-00004-g9eb63ce (martin@shambhala) (gcc=20
version 4.4.5 (Debian 4.4.5-8) ) #1 PREEMPT Thu Jan 13 10:59:19 CET 2011

(vanilla with some recursive mtime patches from Jan Kara, but I had this=20
with unpatched vanilla 2.6.37/ 2.6.36 and 2.6.33 as well)

Often it is just a free thousand pages that are missing.

With TuxOnIce - my current kernels are not having TuxOnIce compiled in -=20
there was a specific mention of to less lowmem pages.

A usual situation where it might fail is:

  shambhala:~> cat /proc/meminfo
  MemTotal:        2073668 kB
  MemFree:          257536 kB
  Buffers:           26480 kB
  Cached:           916328 kB
  SwapCached:        27044 kB
  Active:           795012 kB
  Inactive:         660528 kB
  Active(anon):     289056 kB
  Inactive(anon):   230280 kB
  Active(file):     505956 kB
  Inactive(file):   430248 kB
  Unevictable:           0 kB
  Mlocked:               0 kB
  HighTotal:       1187144 kB
  HighFree:         158040 kB
  LowTotal:         886524 kB
  LowFree:           99496 kB
  SwapTotal:       4000180 kB
  SwapFree:        3797720 kB
  Dirty:             10064 kB
  Writeback:             0 kB
  AnonPages:        496044 kB
  Mapped:            64192 kB
  Shmem:              6604 kB
  Slab:              85540 kB
  SReclaimable:      34572 kB
  SUnreclaim:        50968 kB
  KernelStack:        2776 kB
  PageTables:         7412 kB
  NFS_Unstable:          0 kB
  Bounce:                0 kB
  WritebackTmp:          0 kB
  CommitLimit:     5037012 kB
  Committed_AS:    1708672 kB
  VmallocTotal:     122880 kB
  VmallocUsed:       17320 kB
  VmallocChunk:      92856 kB
  DirectMap4k:      897016 kB
  DirectMap4M:       12288 kB


When I stop Akonadi (with SQlite, not MySQL as backend) - after having=20
closed all other applications of my KDE 4 desktop - hibernation usually=20
works.

But I also found that

echo 3 >/proc/sys/vm/drop_caches helps.

echo 1 frees some pages:

  shambhala:~> echo 1 > /proc/sys/vm/drop_caches
  shambhala:~> cat /proc/meminfo
  MemTotal:        2073668 kB
  MemFree:         1135132 kB
  Buffers:             512 kB
  Cached:            71544 kB
  SwapCached:        27044 kB
  Active:           339008 kB
  Inactive:         245784 kB
  Active(anon):     289060 kB
  Inactive(anon):   230280 kB
  Active(file):      49948 kB
  Inactive(file):    15504 kB
  Unevictable:           0 kB
  Mlocked:               0 kB
  HighTotal:       1187144 kB
  HighFree:         697688 kB
  LowTotal:         886524 kB
  LowFree:          437444 kB
  SwapTotal:       4000180 kB
  SwapFree:        3797720 kB
  Dirty:               444 kB
  Writeback:             0 kB
  AnonPages:        496048 kB
  Mapped:            64228 kB
  Shmem:              6604 kB
  Slab:              78844 kB
  SReclaimable:      27888 kB
  SUnreclaim:        50956 kB
  KernelStack:        2776 kB
  PageTables:         7412 kB
  NFS_Unstable:          0 kB
  Bounce:                0 kB
  WritebackTmp:          0 kB
  CommitLimit:     5037012 kB
  Committed_AS:    1708672 kB
  VmallocTotal:     122880 kB
  VmallocUsed:       17320 kB
  VmallocChunk:      92856 kB
  DirectMap4k:      897016 kB
  DirectMap4M:       12288 kB

echo 2 even more:

  shambhala:~> echo 2 > /proc/sys/vm/drop_caches
  shambhala:~> cat /proc/meminfo
  MemTotal:        2073668 kB
  MemFree:         1209228 kB
  Buffers:            1204 kB
  Cached:            71536 kB
  SwapCached:        27044 kB
  Active:           339024 kB
  Inactive:         246456 kB
  Active(anon):     289064 kB
  Inactive(anon):   230280 kB
  Active(file):      49960 kB
  Inactive(file):    16176 kB
  Unevictable:           0 kB
  Mlocked:               0 kB
  HighTotal:       1187144 kB
  HighFree:         697688 kB
  LowTotal:         886524 kB
  LowFree:          511540 kB
  SwapTotal:       4000180 kB
  SwapFree:        3797720 kB
  Dirty:               380 kB
  Writeback:             0 kB
  AnonPages:        496052 kB
  Mapped:            64228 kB
  Shmem:              6604 kB
  Slab:              68036 kB
  SReclaimable:      17088 kB
  SUnreclaim:        50948 kB
  KernelStack:        2776 kB
  PageTables:         7412 kB
  NFS_Unstable:          0 kB
  Bounce:                0 kB
  WritebackTmp:          0 kB
  CommitLimit:     5037012 kB
  Committed_AS:    1708672 kB
  VmallocTotal:     122880 kB
  VmallocUsed:       17320 kB
  VmallocChunk:      92856 kB
  DirectMap4k:      897016 kB
  DirectMap4M:       12288 kB

Thus the machine has 500 MB of free lowmem and over 1 GB of free highmem=20
of 2 GB of total mem and thus surely should be able to hibernate with ease=
=20
IMHO. Which it does then too.

After an echo 3 onto drop_caches hibernation for now *always* worked, even=
=20
when I left Akregator running - when often with just one open application=20
the machine would not hibernate.

So if dropping caches *and* dir entries manually helps hibernation going=20
why doesn't try PM that hard to free pages in order to let the allocation=20
of the hibernation image be successful?

Are there any other tips? The machine has a whopping 900 MB of caches and=20
there is a lot of free memory usually so actually I do not get why there=20
are any memory issues at all that prevent successful hibernation. I guess=20
that using a 64 bit machine with more memory and without that hysteric=20
differentiation between lowmem and highmem pages that I never got coming=20
from the Amiga will help out all those issues, but still I'd like to know=20
why its failing with 2 GB of RAM of which 1.5 GB are basically fire -=20
unless I drop caches and dir entries manually.

I will now continue use

echo 3 > /proc/sys/vm/drop_caches

prior to hibernation to check whether it really fixed memory issues during=
=20
hibernation.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1380842.Q2kA83GQZ3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk1kI8gACgkQmRvqrKWZhMd7zwCfaAW+GXLyQp4qqcwionWMbaVQ
ezcAnRrMn+cyCcf/cHjF2iHrDY5ZN++Q
=xa3n
-----END PGP SIGNATURE-----

--nextPart1380842.Q2kA83GQZ3--
