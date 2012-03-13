Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab2CMBnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:43:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55615 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab2CMBnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:43:11 -0400
Date: Tue, 13 Mar 2012 12:43:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the pci tree with the powerpc tree
Message-Id: <20120313124301.ddab25f7329bd24fc0ede50d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_12_43_01_+1100_ETFmqMu2BGUs43Uv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_12_43_01_+1100_ETFmqMu2BGUs43Uv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

Today's linux-next merge of the pci tree got a conflict in
arch/powerpc/include/asm/ppc-pci.h between commit cb3bc9d0de1e
("powerpc/eeh: Cleanup comments in the EEH core") from the powerpc tree
and commit 673c97562489 ("powerpc/PCI: replace pci_probe_only with
pci_flags") from the pci tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/include/asm/ppc-pci.h
index e660b37,f4f7ad8..0000000
--- a/arch/powerpc/include/asm/ppc-pci.h
+++ b/arch/powerpc/include/asm/ppc-pci.h
@@@ -45,23 -45,92 +45,21 @@@ extern void init_pci_config_tokens (voi
  extern unsigned long get_phb_buid (struct device_node *);
  extern int rtas_setup_phb(struct pci_controller *phb);
 =20
- extern unsigned long pci_probe_only;
-=20
 -/* ---- EEH internal-use-only related routines ---- */
  #ifdef CONFIG_EEH
 =20
 +void pci_addr_cache_build(void);
  void pci_addr_cache_insert_device(struct pci_dev *dev);
  void pci_addr_cache_remove_device(struct pci_dev *dev);
 -void pci_addr_cache_build(void);
 -struct pci_dev *pci_get_device_by_addr(unsigned long addr);
 -
 -/**
 - * eeh_slot_error_detail -- record and EEH error condition to the log
 - * @pdn:      pci device node
 - * @severity: EEH_LOG_TEMP_FAILURE or EEH_LOG_PERM_FAILURE
 - *
 - * Obtains the EEH error details from the RTAS subsystem,
 - * and then logs these details with the RTAS error log system.
 - */
 -#define EEH_LOG_TEMP_FAILURE 1
 -#define EEH_LOG_PERM_FAILURE 2
 -void eeh_slot_error_detail (struct pci_dn *pdn, int severity);
 -
 -/**
 - * rtas_pci_enable - enable IO transfers for this slot
 - * @pdn:       pci device node
 - * @function:  either EEH_THAW_MMIO or EEH_THAW_DMA=20
 - *
 - * Enable I/O transfers to this slot=20
 - */
 -#define EEH_THAW_MMIO 2
 -#define EEH_THAW_DMA  3
 -int rtas_pci_enable(struct pci_dn *pdn, int function);
 -
 -/**
 - * rtas_set_slot_reset -- unfreeze a frozen slot
 - * @pdn:       pci device node
 - *
 - * Clear the EEH-frozen condition on a slot.  This routine
 - * does this by asserting the PCI #RST line for 1/8th of
 - * a second; this routine will sleep while the adapter is
 - * being reset.
 - *
 - * Returns a non-zero value if the reset failed.
 - */
 -int rtas_set_slot_reset (struct pci_dn *);
 -int eeh_wait_for_slot_status(struct pci_dn *pdn, int max_wait_msecs);
 -
 -/**=20
 - * eeh_restore_bars - Restore device configuration info.
 - * @pdn:       pci device node
 - *
 - * A reset of a PCI device will clear out its config space.
 - * This routines will restore the config space for this
 - * device, and is children, to values previously obtained
 - * from the firmware.
 - */
 -void eeh_restore_bars(struct pci_dn *);
 -
 -/**
 - * rtas_configure_bridge -- firmware initialization of pci bridge
 - * @pdn:       pci device node
 - *
 - * Ask the firmware to configure all PCI bridges devices
 - * located behind the indicated node. Required after a
 - * pci device reset. Does essentially the same hing as
 - * eeh_restore_bars, but for brdges, and lets firmware=20
 - * do the work.
 - */
 -void rtas_configure_bridge(struct pci_dn *);
 -
 +struct pci_dev *pci_addr_cache_get_device(unsigned long addr);
 +void eeh_slot_error_detail(struct eeh_dev *edev, int severity);
 +int eeh_pci_enable(struct eeh_dev *edev, int function);
 +int eeh_reset_pe(struct eeh_dev *);
 +void eeh_restore_bars(struct eeh_dev *);
  int rtas_write_config(struct pci_dn *, int where, int size, u32 val);
  int rtas_read_config(struct pci_dn *, int where, int size, u32 *val);
 -
 -/**
 - * eeh_mark_slot -- set mode flags for pertition endpoint
 - * @pdn:       pci device node
 - *
 - * mark and clear slots: find "partition endpoint" PE and set or=20
 - * clear the flags for each subnode of the PE.
 - */
 -void eeh_mark_slot (struct device_node *dn, int mode_flag);
 -void eeh_clear_slot (struct device_node *dn, int mode_flag);
 -
 -/**
 - * find_device_pe -- Find the associated "Partiationable Endpoint" PE
 - * @pdn:       pci device node
 - */
 -struct device_node * find_device_pe(struct device_node *dn);
 +void eeh_mark_slot(struct device_node *dn, int mode_flag);
 +void eeh_clear_slot(struct device_node *dn, int mode_flag);
 +struct device_node *eeh_find_device_pe(struct device_node *dn);
 =20
  void eeh_sysfs_add_device(struct pci_dev *pdev);
  void eeh_sysfs_remove_device(struct pci_dev *pdev);

--Signature=_Tue__13_Mar_2012_12_43_01_+1100_ETFmqMu2BGUs43Uv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXqYlAAoJEECxmPOUX5FELWEP/1LBzJWW+9Qy0oej5VeU8XZ9
QW/3N+tb8ZtvDQuOYZKWK2JVqrieJ6fFYS7OrKFc85ws7C4DR2IgMM3/Oi9HZh4f
z6byWSS4LLp4Z4Dnt2EI7aE9lF3b0hY4tJk687ZJL0zSpigLMHmx/iFhJSKaCYPq
vyIrPa0hBGUnzAjmCasmHQP6QiUIN+u2cTRmtZNhfO3ZtfqXpQdHXFBfNZ5vP2Hi
o1qP5JJMCHBFH7dsK0lf3ixNg/KlXzaoDo+xmc4S14FNmAAcqZa3bmc6wIkMLRL/
4dJa7oXDiEZ5UE+oBhZ4HEXYAmH+O8D6zfxt/W0HXd6PtqPt+OoKTpfM6nxnjbKX
zmHqbESGPwl98QjzjRzEbbZeeJf0VLHAE5Sfi0JDkcY/vwEyI3onPs3ZYXKq6Wly
59JOdIMgF8ibX5ZPSLinf7WOWB3OpqtCCg2WA3E+Qxcn8p8+7GPiGRBQRvk7ITg0
Dn/hhYFzk7vVLGbTl++CStNd7YRl7SUodBmVBSG8KmPNwMpvIPj47Pogl0w9bROf
s9Q6EfuoqnIdXZ7XKW86U/zch9WYkz+Lrh+86QIfjhgzR8rrAaebkS+zdxt9HxA2
hYgltrCXcrsW26R2BQtvqyvz4D7EuYxz6uP23BHbMT/tbmxE2nH636cp+LyG3lRd
p8IF7i4DHUV2eAA2cZ31
=D2V/
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_12_43_01_+1100_ETFmqMu2BGUs43Uv--
