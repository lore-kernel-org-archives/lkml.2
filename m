Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1LDTAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:00:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab1LDTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:12 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=IMyC9s0TaQQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=WTJdmG3rAAAA:8 a=QyXUC8HyAAAA:8 a=EujyWprOPbVT4QmRI6oA:9 a=hMXUejMU2wBl2SxLJHMA:7 a=QEXdDO2ut3YA:10 a=nsF78Xlgl7EA:10 a=dGJ0OcVc7YAA:10 a=HaZgEIiIQuseKov0STwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204190008.804987080@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Roland Dreier <roland@purestorage.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH 03/11] intel-iommu: Fix AB-BA lockdep report
References: <20111204185444.411298317@goodmis.org>
Content-Disposition: inline; filename=0003-intel-iommu-Fix-AB-BA-lockdep-report.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Roland Dreier <roland@purestorage.com>

When unbinding a device so that I could pass it through to a KVM VM, I
got the lockdep report below.  It looks like a legitimate lock
ordering problem:

 - domain_context_mapping_one() takes iommu->lock and calls
   iommu_support_dev_iotlb(), which takes device_domain_lock (inside
   iommu->lock).

 - domain_remove_one_dev_info() starts by taking device_domain_lock
   then takes iommu->lock inside it (near the end of the function).

So this is the classic AB-BA deadlock.  It looks like a safe fix is to
simply release device_domain_lock a bit earlier, since as far as I can
tell, it doesn't protect any of the stuff accessed at the end of
domain_remove_one_dev_info() anyway.

BTW, the use of device_domain_lock looks a bit unsafe to me... it's
at least not obvious to me why we aren't vulnerable to the race below:

  iommu_support_dev_iotlb()
                                          domain_remove_dev_info()

  lock device_domain_lock
    find info
  unlock device_domain_lock

                                          lock device_domain_lock
                                            find same info
                                          unlock device_domain_lock

                                          free_devinfo_mem(info)

  do stuff with info after it's free

However I don't understand the locking here well enough to know if
this is a real problem, let alone what the best fix is.

Anyway here's the full lockdep output that prompted all of this:

     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
     [ INFO: possible circular locking dependency detected ]
     2.6.39.1+ #1
     -------------------------------------------------------
     bash/13954 is trying to acquire lock:
      (&(&iommu->lock)->rlock){......}, at: [<ffffffff812f6421>] domain_rem=
ove_one_dev_info+0x121/0x230

     but task is already holding lock:
      (device_domain_lock){-.-...}, at: [<ffffffff812f6508>] domain_remove_=
one_dev_info+0x208/0x230

     which lock already depends on the new lock.

     the existing dependency chain (in reverse order) is:

     -> #1 (device_domain_lock){-.-...}:
            [<ffffffff8109ca9d>] lock_acquire+0x9d/0x130
            [<ffffffff81571475>] _raw_spin_lock_irqsave+0x55/0xa0
            [<ffffffff812f8350>] domain_context_mapping_one+0x600/0x750
            [<ffffffff812f84df>] domain_context_mapping+0x3f/0x120
            [<ffffffff812f9175>] iommu_prepare_identity_map+0x1c5/0x1e0
            [<ffffffff81ccf1ca>] intel_iommu_init+0x88e/0xb5e
            [<ffffffff81cab204>] pci_iommu_init+0x16/0x41
            [<ffffffff81002165>] do_one_initcall+0x45/0x190
            [<ffffffff81ca3d3f>] kernel_init+0xe3/0x168
            [<ffffffff8157ac24>] kernel_thread_helper+0x4/0x10

     -> #0 (&(&iommu->lock)->rlock){......}:
            [<ffffffff8109bf3e>] __lock_acquire+0x195e/0x1e10
            [<ffffffff8109ca9d>] lock_acquire+0x9d/0x130
            [<ffffffff81571475>] _raw_spin_lock_irqsave+0x55/0xa0
            [<ffffffff812f6421>] domain_remove_one_dev_info+0x121/0x230
            [<ffffffff812f8b42>] device_notifier+0x72/0x90
            [<ffffffff8157555c>] notifier_call_chain+0x8c/0xc0
            [<ffffffff81089768>] __blocking_notifier_call_chain+0x78/0xb0
            [<ffffffff810897b6>] blocking_notifier_call_chain+0x16/0x20
            [<ffffffff81373a5c>] __device_release_driver+0xbc/0xe0
            [<ffffffff81373ccf>] device_release_driver+0x2f/0x50
            [<ffffffff81372ee3>] driver_unbind+0xa3/0xc0
            [<ffffffff813724ac>] drv_attr_store+0x2c/0x30
            [<ffffffff811e4506>] sysfs_write_file+0xe6/0x170
            [<ffffffff8117569e>] vfs_write+0xce/0x190
            [<ffffffff811759e4>] sys_write+0x54/0xa0
            [<ffffffff81579a82>] system_call_fastpath+0x16/0x1b

     other info that might help us debug this:

     6 locks held by bash/13954:
      #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811e4464>] sysfs_write_f=
ile+0x44/0x170
      #1:  (s_active#3){++++.+}, at: [<ffffffff811e44ed>] sysfs_write_file+=
0xcd/0x170
      #2:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81372edb>] dri=
ver_unbind+0x9b/0xc0
      #3:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81373cc7>] dev=
ice_release_driver+0x27/0x50
      #4:  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at: [<ffffffff8108974f>=
] __blocking_notifier_call_chain+0x5f/0xb0
      #5:  (device_domain_lock){-.-...}, at: [<ffffffff812f6508>] domain_re=
move_one_dev_info+0x208/0x230

     stack backtrace:
     Pid: 13954, comm: bash Not tainted 2.6.39.1+ #1
     Call Trace:
      [<ffffffff810993a7>] print_circular_bug+0xf7/0x100
      [<ffffffff8109bf3e>] __lock_acquire+0x195e/0x1e10
      [<ffffffff810972bd>] ? trace_hardirqs_off+0xd/0x10
      [<ffffffff8109d57d>] ? trace_hardirqs_on_caller+0x13d/0x180
      [<ffffffff8109ca9d>] lock_acquire+0x9d/0x130
      [<ffffffff812f6421>] ? domain_remove_one_dev_info+0x121/0x230
      [<ffffffff81571475>] _raw_spin_lock_irqsave+0x55/0xa0
      [<ffffffff812f6421>] ? domain_remove_one_dev_info+0x121/0x230
      [<ffffffff810972bd>] ? trace_hardirqs_off+0xd/0x10
      [<ffffffff812f6421>] domain_remove_one_dev_info+0x121/0x230
      [<ffffffff812f8b42>] device_notifier+0x72/0x90
      [<ffffffff8157555c>] notifier_call_chain+0x8c/0xc0
      [<ffffffff81089768>] __blocking_notifier_call_chain+0x78/0xb0
      [<ffffffff810897b6>] blocking_notifier_call_chain+0x16/0x20
      [<ffffffff81373a5c>] __device_release_driver+0xbc/0xe0
      [<ffffffff81373ccf>] device_release_driver+0x2f/0x50
      [<ffffffff81372ee3>] driver_unbind+0xa3/0xc0
      [<ffffffff813724ac>] drv_attr_store+0x2c/0x30
      [<ffffffff811e4506>] sysfs_write_file+0xe6/0x170
      [<ffffffff8117569e>] vfs_write+0xce/0x190
      [<ffffffff811759e4>] sys_write+0x54/0xa0
      [<ffffffff81579a82>] system_call_fastpath+0x16/0x1b

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/intel-iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8c2564d..bc05a51 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3569,6 +3569,8 @@ static void domain_remove_one_dev_info(struct dmar_do=
main *domain,
 			found =3D 1;
 	}
=20
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+
 	if (found =3D=3D 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
@@ -3585,8 +3587,6 @@ static void domain_remove_one_dev_info(struct dmar_do=
main *domain,
 			spin_unlock_irqrestore(&iommu->lock, tmp_flags);
 		}
 	}
-
-	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
=20
 static void vm_domain_remove_all_dev_info(struct dmar_domain *domain)
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO28M5AAoJEIy3vGnGbaoAv1wQANuXblZPDueIHA4cNARAYcQX
xkFPQKWr+T2Uk1vxozVsS+3hF9pW8ibPiRfA4l7Fh14HPn0PJPg3vTrGwGGs90JH
A6KeA7G4EsHCzC4S3fWv+Zn3+cSUqSBUTvtKQStUwXDcO9rb0ZrfmgsBxG1B0r2A
2bfcQFRr5izPH9wHREJseTI8W4rQSZayj6ZC6KIHLjmITDZfO4JA1XjPOo/yE7JG
lFWZAJrjEWwjs6QmRQvxinRSrvmmPI3iixz0h51oh7x7x6/MD+GWM74oV01SFqtU
aJvX/4jj4DN9T64H5Q3UCdcc/221LwgIU/p7zp0G8R7Tj/FLN/YA3nwQs9kGe3jL
uM3vNQiaEI0xauEReW4hmNqc94HoYSQrfrQB0md+k7qPlOyl1gt6SXcKCFXw6OUB
KnHtDcrqd0bCeRZAhPcT8WXDHlljpLHG1Y8SlUvIRfuROTRA963pyarD8mHHPZNO
gXh3RBRnBnp8nS1uMynKqmYIXHgwRj/5KDm6V7W5mTYarcoG4Yrwn05uIlf/EznX
VnvL0Q+1z3KQ2X3XDSxo8BROgLsl9Ij3ggFDn+IMN9XR8BPGAOLgaBE9qQIw4zNc
O/EP1jDWw66fkJuF1SLvzuXf08uOoQQ/5jhTlRAbpxzg/8hMjWXJ2VTfWB/QApcC
tYJsOv6fUKi45yxab3vE
=gd/6
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
