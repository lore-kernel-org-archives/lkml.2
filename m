Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2GFFMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:12:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32899 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2GFFMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:12:34 -0400
Date: Fri, 6 Jul 2012 15:12:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20120706151223.fa37a2ec38c586ee32b74c5b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_15_12_23_+1000_Vw2WqFuvIW/+IxFn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jul_2012_15_12_23_+1000_Vw2WqFuvIW/+IxFn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
Documentation/virtual/kvm/api.txt between commit f36992e31284 ("KVM: Add
missing KVM_IRQFD API documentation") from Linus' tree and commit
32fad281c068 ("KVM: PPC: Book3S HV: Make the guest hash table size
configurable") from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/virtual/kvm/api.txt
index 2c99483,310fe50..0000000
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@@ -1930,22 -1930,41 +1930,56 @@@ The "pte_enc" field provides a value th
  PTE's RPN field (ie, it needs to be shifted left by 12 to OR it
  into the hash PTE second double word).
 =20
 +4.75 KVM_IRQFD
 =20
 -4.75 KVM_PPC_ALLOCATE_HTAB
 +Capability: KVM_CAP_IRQFD
 +Architectures: x86
 +Type: vm ioctl
 +Parameters: struct kvm_irqfd (in)
 +Returns: 0 on success, -1 on error
 +
 +Allows setting an eventfd to directly trigger a guest interrupt.
 +kvm_irqfd.fd specifies the file descriptor to use as the eventfd and
 +kvm_irqfd.gsi specifies the irqchip pin toggled by this event.  When
 +an event is tiggered on the eventfd, an interrupt is injected into
 +the guest using the specified gsi pin.  The irqfd is removed using
 +the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
 +and kvm_irqfd.gsi.
 +
++4.76 KVM_PPC_ALLOCATE_HTAB
+=20
+ Capability: KVM_CAP_PPC_ALLOC_HTAB
+ Architectures: powerpc
+ Type: vm ioctl
+ Parameters: Pointer to u32 containing hash table order (in/out)
+ Returns: 0 on success, -1 on error
+=20
+ This requests the host kernel to allocate an MMU hash table for a
+ guest using the PAPR paravirtualization interface.  This only does
+ anything if the kernel is configured to use the Book 3S HV style of
+ virtualization.  Otherwise the capability doesn't exist and the ioctl
+ returns an ENOTTY error.  The rest of this description assumes Book 3S
+ HV.
+=20
+ There must be no vcpus running when this ioctl is called; if there
+ are, it will do nothing and return an EBUSY error.
+=20
+ The parameter is a pointer to a 32-bit unsigned integer variable
+ containing the order (log base 2) of the desired size of the hash
+ table, which must be between 18 and 46.  On successful return from the
+ ioctl, it will have been updated with the order of the hash table that
+ was allocated.
+=20
+ If no hash table has been allocated when any vcpu is asked to run
+ (with the KVM_RUN ioctl), the host kernel will allocate a
+ default-sized hash table (16 MB).
+=20
+ If this ioctl is called when a hash table has already been allocated,
+ the kernel will clear out the existing hash table (zero all HPTEs) and
+ return the hash table order in the parameter.  (If the guest is using
+ the virtualized real-mode area (VRMA) facility, the kernel will
+ re-create the VMRA HPTEs on the next KVM_RUN of any vcpu.)
+=20
 =20
  5. The kvm_run structure
  ------------------------

--Signature=_Fri__6_Jul_2012_15_12_23_+1000_Vw2WqFuvIW/+IxFn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9nO3AAoJEECxmPOUX5FElhUP/3N9dbJnncPalWyADmuhijtc
U8Ct3m7nz9Ft/GA6mIOf8V9LYYYLaso794SnfHYqf7npC90ohLog6ysQucPot8UD
lZKIRZLyNkcJPgV9PAf6LyLrwrPNTIRrKLNmVwhlel6u7zYAn/rMp2zj4EJr8lPE
UlVmgjaw+Rd1fp38dsTC2Oa6/OrBCAvwBGxBil9B2Nkms0+Qz96rbFZcCoi6TsIz
fDXxTU0UXa/HyCibrmpJ3ubUrnndyFXZ/66yLcWjU+c8F6gmW0LhI/jGvNW8Y1HI
yBUYsxHuiEteyetpzOwfuEzIIVFXBNFU6Avcc554eoLZXy8pGNc2489Givd5jEC/
SrL0wRZQeVyY92e6wIQ+sERW9NqU7QtLv3DhwgoZ2V/KzMEXHpDOgdGapLa79Ozm
pEn/O8aGWgbe2Ktg8+naRKpFH7Me1YYISJpdecySjbaxPwV7ISlaZfGvbShif23n
kIOHegnB/bT8Y2qwzR0/h/jymfU0Tq6IlFG6oeiaxvn8mrK/1b9WBh6KUcPqeb96
95rwYRtX6ccL4wWx44s/yiVhOtW9QFESLBGO3BZx+6WpoLhhNfDrY8Xeb7PzQPbe
sYEH9diEXl5f5HY9FrUuXa3kiLIDwD3wfsPSTWdi4RSTA6hiQOSNOFsZJp87xF46
WnAnay8bA1qnXZwvi5Ee
=CwBT
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_15_12_23_+1000_Vw2WqFuvIW/+IxFn--
