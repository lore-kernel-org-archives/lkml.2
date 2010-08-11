Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab0HKKbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 06:31:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46165 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0HKKbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 06:31:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dhyglOMgdFizS1P0ou92JQoSwt96i05efPhkFIjVZBpWM9drsrhj6APXsGXuMe2Xyw
         55EH1z8CXMZFNxVVlsNIySgh6WJivqCrV5nemFINqgZShCPDqHZgh6NYzWQc/FTIT9iL
         NDdGrFydQG9SGnmQrB7t9aS5Lo/dKeTdMfq2E=
Date: Wed, 11 Aug 2010 13:35:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: convert reiserfs to ->evict_inode()
Message-ID: <20100811103550.GA6372@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

commit 845a2cc0507055278e0fa722ed0f8c791b7401dd introduced:

@@ -77,9 +79,14 @@ void reiserfs_delete_inode(struct inode *inode)
                ;
        }
       out:
-       clear_inode(inode);     /* note this must go after the journal_end =
to prevent deadlock */
+       end_writeback(inode);   /* note this must go after the journal_end =
to prevent deadlock */
+       dquot_drop(inode);
        inode->i_blocks =3D 0;
        reiserfs_write_unlock_once(inode->i_sb, depth);
+
+no_delete:
+       end_writeback(inode);
+       dquot_drop(inode);
 }


We will have problems here when going to end_writeback second time.

Probably should be:
@@ -77,9 +79,14 @@ void reiserfs_delete_inode(struct inode *inode)
                ;                                                =20
        }       =20
       out:  =20
-       clear_inode(inode);     /* note this must go after the journal_end =
to prevent deadlock */
+       end_writeback(inode);   /* note this must go after the journal_end =
to prevent deadlock */
+       dquot_drop(inode);
        inode->i_blocks =3D 0;
        reiserfs_write_unlock_once(inode->i_sb, depth);
+	return;
	^^^^^^
+
+no_delete:
+       end_writeback(inode);
+       dquot_drop(inode);
 }



[ 2347.942981] kernel BUG at fs/inode.c:298!
[ 2347.945553] invalid opcode: 0000 [#8] PREEMPT SMP=20
[ 2347.948133] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A0=
8:00/device:13/PNP0C0A:00/power_supply/BAT0/current_now
[ 2347.950770] CPU 2=20
[ 2347.950791] Modules linked in: ipv6 snd_hwdep snd_hda_codec_atihdmi snd_=
seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss=
 snd_hda_codec_realtek snd_mixer_oss ac battery snd_hda_intel snd_hda_codec=
 snd_pcm
snd_timer wmi snd soundcore snd_page_alloc button processor thermal broadco=
m usbhid hid tg3 libphy psmouse intel_ips serio_raw evdev radeon ttm drm_km=
s_helper ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
[ 2347.961651]=20
[ 2347.964423] Pid: 6301, comm: mconf Tainted: G      D     2.6.36-rc0-git1=
1-07128-g4104046-dirty #104 Aspire 5741G    /Aspire 5741G   =20
[ 2347.967369] RIP: 0010:[<ffffffff810ebc58>]  [<ffffffff810ebc58>] end_wri=
teback+0x3b/0x6d
[ 2347.967388] RSP: 0018:ffff8801359d5ca8  EFLAGS: 00010202
[ 2347.967394] RAX: 0000000000000060 RBX: ffff880123120a58 RCX: 00000000fff=
fffff
[ 2347.967400] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8801231=
20a58
[ 2347.967406] RBP: ffff8801359d5cb8 R08: 000000000002428a R09: 00000000000=
2428a
[ 2347.967411] R10: ffff8801359d5828 R11: ffff8801359d58b8 R12: 00000000000=
00000
[ 2347.967417] R13: 0000000000000024 R14: 00000000ffffffff R15: 00000000000=
00000
[ 2347.967425] FS:  00002b1e2b68fde0(0000) GS:ffff880002280000(0000) knlGS:=
0000000000000000
[ 2347.967431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2347.967436] CR2: 00002b1e2b3934d0 CR3: 000000013599a000 CR4: 00000000000=
006e0
[ 2347.967442] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2347.967448] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2347.967455] Process mconf (pid: 6301, threadinfo ffff8801359d4000, task =
ffff880155700000)
[ 2347.967460] Stack:
[ 2347.967463]  ffff8801359d5cb8 ffff880123120a58 ffff8801359d5d28 ffffffff=
8113a1f8
[ 2347.967472] <0> ffff880155543800 0000000000000000 0000000000000000 00000=
00000000000
[ 2347.967481] <0> 0000000000000000 0000000000000000 0000000000000000 00000=
00000000001
[ 2347.967491] Call Trace:
[ 2347.967502]  [<ffffffff8113a1f8>] reiserfs_evict_inode+0x13c/0x151
[ 2347.967513]  [<ffffffff810ebcac>] evict+0x22/0x92
[ 2347.967517]  [<ffffffff810ec884>] iput+0x1c8/0x228
[ 2347.967521]  [<ffffffff810e8e64>] dentry_iput+0xb0/0xc8
[ 2347.967525]  [<ffffffff810e8ec8>] d_kill+0x4c/0x6c
[ 2347.967528]  [<ffffffff810e9719>] dput+0x14c/0x159
[ 2347.967532]  [<ffffffff810e53f0>] sys_renameat+0x1ae/0x200
[ 2347.967541]  [<ffffffff810557b9>] ? up_read+0x1e/0x35
[ 2347.967546]  [<ffffffff81022150>] ? do_page_fault+0x32b/0x36b
[ 2347.967552]  [<ffffffff810bff27>] ? do_munmap+0x2c3/0x2dc
[ 2347.967558]  [<ffffffff8136d7d6>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 2347.967562]  [<ffffffff810e5458>] sys_rename+0x16/0x1a
[ 2347.967568]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b


	Sergey
--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxifQYACgkQfKHnntdSXjQ3ggQA3KjkqpycrzIWXgLfwOat3EdP
sjtU/A00Sqel8LBEVerLb4W+c9bka16YtnJF90vYjnFaKNo2cke9aAS+IY4Id4TK
tkn/xtwRWm/WM+Ily1JmG0uqzQ7TY+qQHHdWgekjTYkJ48JpezQX1tatgPiD9UWt
wlRpmF/12jP44gymJfE=
=ecfK
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
