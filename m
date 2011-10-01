Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1JAJ3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 05:29:07 -0400
Received: from swan.madduck.net ([80.68.90.58]:37566 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab1JAJ3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 05:29:01 -0400
Date: Sat, 1 Oct 2011 11:28:58 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: I/O scheduler on its knees, pvmove hangs other tasks
Message-ID: <20111001092858.GA12945@albatross.gern.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux wheezy/sid kernel 3.1.0-rc4-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear list,

I have a system with a LVM VG on a RAID6 (md). I need to decrease
the size of the md to make room for another partition. Therefore,
I employ pvmove with the anywhere allocation strategy to move the
physical extents at the end of the disk to the front.

In order to not disturb the system too much, I use ionice -c3 to put
both, pvmove and the associated kcopyd process into the idle I/O
scheduling class. The disk block devices use the cfq scheduler.

The problem is that the kernel seems not to care. The pvmove process
happily chugs along at what seems to be maximum speed. At the same
time, other processes, like /bin/ls simply block and remain in 'D'
state *forever*. Even after the pvmove process exits, these
processes do not recover.

The kernel tells me about the hung tasks, but I cannot really make
sense out of this information.

 INFO: task ls:4870 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 ls            D 0000000000000002     0  4870   4667 0x00000000
  ffff880037814db0 0000000000000086 ffff880079b89a40 0000000000000000
  0000000000000001 0000000000000296 000000000000f9e0 ffff880079ca1fd8
  0000000000015780 0000000000015780 ffff88007a4662e0 ffff88007a4665d8
 Call Trace:
  [<ffffffffa048c563>] ? put_ldev+0x2d/0x6f [drbd]
  [<ffffffffa01112c4>] ? dm_table_unplug_all+0x4b/0xb4 [dm_mod]
  [<ffffffff8101657d>] ? read_tsc+0xa/0x20
  [<ffffffff8117e023>] ? generic_make_request+0x299/0x2f9
  [<ffffffff8110e146>] ? sync_buffer+0x0/0x40
  [<ffffffff812fafca>] ? io_schedule+0x73/0xb7
  [<ffffffff8110e181>] ? sync_buffer+0x3b/0x40
  [<ffffffff812fb4d7>] ? __wait_on_bit+0x41/0x70
  [<ffffffff8110e146>] ? sync_buffer+0x0/0x40
  [<ffffffff812fb571>] ? out_of_line_wait_on_bit+0x6b/0x77
  [<ffffffff81064f44>] ? wake_bit_function+0x0/0x23
  [<ffffffffa0156a09>] ? __ext4_get_inode_loc+0x2d8/0x32e [ext4]
  [<ffffffff81100b21>] ? inode_init_always+0x109/0x1aa
  [<ffffffffa0156f9f>] ? ext4_iget+0x5a/0x6ed [ext4]
  [<ffffffffa015f911>] ? ext4_lookup+0x83/0xe1 [ext4]
  [<ffffffff810f64c3>] ? do_lookup+0xd3/0x15d
  [<ffffffff810f6ef0>] ? __link_path_walk+0x5a5/0x6f5
  [<ffffffff810b41a5>] ? lock_page+0x9/0x1f
  [<ffffffff810f726e>] ? path_walk+0x66/0xc9
  [<ffffffff810f86d8>] ? do_path_lookup+0x20/0x77
  [<ffffffff810f9bba>] ? user_path_at+0x48/0x79
  [<ffffffff810ccb2f>] ? handle_mm_fault+0x3b8/0x80f
  [<ffffffff810d018d>] ? get_unmapped_area+0xd7/0x139
  [<ffffffff810f2006>] ? vfs_fstatat+0x2c/0x57
  [<ffffffff810f2087>] ? sys_newlstat+0x11/0x30
  [<ffffffff812fe760>] ? do_page_fault+0x2da/0x2f2
  [<ffffffff812fc605>] ? page_fault+0x25/0x30
  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

Any input appreciated, specifically answers to the following
questions:

  - how can I fix I/O scheduling so that pvmove/kcopyd and the rest
    of the system share nicely?

  - how can I revive these 'D'-processes?

This is on Debian squeeze, amd64, with a 2.6.32 kernel and the cfq
scheduler. The underlying disks are WD Caviar Green (I know they
suck at performance=E2=80=A6), and the partitions are currently not aligned
to 4k sectors =E2=80=94 which is what I am trying to fix.

Cheers,

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"da haben wir es also: eine kirchliche ordnung mit priesterschaft,
 theologie, kultus, sakrament;
 kurz, alles das, was jesus von nazareth bek=C3=A4mpft hatte..."
                                                 - friedrich nietzsche
=20
spamtraps: madduck.bogus@madduck.net

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQLvBAEBCgDZBQJOht1VwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xDSc
D/9HJl9leDTFJhqj4A4nvK/9QWRl5l+AA+2JIOY32WMotmsE0uah6bcnBPVPx902
MfA9PvBZeLbJ8dxmFrv/ahgc+qvij1w6JgSJ49Pbfyn+2Rk6IlIBoOCKLVdWFShP
cmYbqveVTZPNYx8k3ibkTADKK4vrX6NpCXMCd9XR/PNaIt55vmaOR9zLlOQ4y/1T
AlQdlo1pxrFgcxA3cZ7yzLoAU9Vu7u8nwzXpQZ0l4w0Qm13g60+mCNg2rdoxC8mV
nUqUcDl3a+6GA1RvPsOnpcg4oWalDgijEDBgBTg0Bsse9NJVkz+YBeU+aLVoNYkk
xsORhIQUGog5XkHToZiMtPB6MNFX/vIl17LUWnTG5jPT7wGRNEd7A15OQMfYrjNS
uaX01cFv7GfHsL3fyJwmer+hxz+GCTfV9mZOAj952o57m68edOXcsTRJGqVo12XR
VSNnxXaNLtNCvc2nvoN7IFCW3oEwu0Qpn+C88mdANcspgPeTW641grSzOYfadNOm
oEGG8H1AB0TlgZPenVLSMNCpF1/ZCv0NxC5O0IgT5OW2YJiilqzgFP12KY076R44
Q8fZQOxc8LzJdDviRSxeJuHycSWCTJqyPlO2ICPDHz4bMwQoZuuV0hVprAjcrZFm
rMe1F1pM/I4H1VWuvuei7PoX3Jgl8jnQFyzmOWDo0+5r9Q==
=T53M
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--

