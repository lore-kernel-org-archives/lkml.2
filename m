Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2CWWdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:33:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50657 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2CWWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:33:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120323201251.GA28567@srcf.ucam.org>
References: <20120323162930.GB23376@srcf.ucam.org>
	<CAMfrEMb9R8V=VagAzi1DJWXrSOJ-dSptdt9aQX=_igjBXF1USw@mail.gmail.com>
	<20120323165118.GA24014@srcf.ucam.org>
	<CAMfrEMa6EAsLMMvG-Yq03E0Qhc7jdk2WH5fvQUB16W-5=Qgfbw@mail.gmail.com>
	<20120323172053.GA24571@srcf.ucam.org>
	<CAMfrEMYFMtSuWPwJ+YVMEBAWwR7tAmrNrSqOhHAZmZAmR6D7yQ@mail.gmail.com>
	<20120323191716.GA27307@srcf.ucam.org>
	<CAMfrEMbhQCFAFG-RFhHcRQiZMNYPpT-MbA6hHsDHu-Y_51bYSg@mail.gmail.com>
	<20120323192152.GA27457@srcf.ucam.org>
	<CAMfrEMbcy-s1WiJqDCDb6BywDzR4HW77i0V7e9B_yRMweQZKCg@mail.gmail.com>
	<20120323201251.GA28567@srcf.ucam.org>
Date: Fri, 23 Mar 2012 17:33:14 -0500
Message-ID: <CAMfrEMbuGY5Gkts_YO1weeij6s-7i87Dx2Oy8KUcKR9zS0cLdA@mail.gmail.com>
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop 3.3.0-030300-generic
From: Chris Holland <bandidoirlandes@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 3:12 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Mar 23, 2012 at 03:10:14PM -0500, Chris Holland wrote:
>
>> I think I had the commit 4949be16822e92a18ea0cc1616319926628092ee
>> removed when I applied the patch.
>>
>> I did a
>> git reset --hard v3.3
>> applied the patch and am rebuilding.
>
> Thanks - let me know if it helps!
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org

That did not work for me after I build I still dont get the cd and dvd in dmesg

And cat /var/log/dmesg | egrep '(CD|DVD)'
[    0.000000] Linux version 3.3.0+ (root@desktop) (gcc version 4.6.1
(Ubuntu/Linaro 4.6.1-9ubuntu3) ) #10 SMP Fri Mar 23 16:09:17 CDT 2012
[    0.000000]   CD000-EFFFF uncachable

What I did

git reset --hard v3.3
git apply patch1
make oldconfig
fakeroot make deb-pkg
install reboot

git diff
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 24f049e..04eb680 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -185,6 +185,7 @@ static void
pcie_aspm_configure_common_clock(struct pcie_link_state *link)
        int ppos, cpos, same_clock = 1;
        u16 reg16, parent_reg, child_reg[8];
        unsigned long start_jiffies;
+       bool retrain = false;
        struct pci_dev *child, *parent = link->pdev;
        struct pci_bus *linkbus = parent->subordinate;
        /*
@@ -215,7 +216,10 @@ static void
pcie_aspm_configure_common_clock(struct pcie_link_state *link)
                        reg16 |= PCI_EXP_LNKCTL_CCC;
                else
                        reg16 &= ~PCI_EXP_LNKCTL_CCC;
-               pci_write_config_word(child, cpos + PCI_EXP_LNKCTL, reg16);
+               if (reg16 != child_reg[PCI_FUNC(child->devfn)]) {
+                       retrain = true;
+                       pci_write_config_word(child, cpos +
PCI_EXP_LNKCTL, reg16);
+               }
        }

        /* Configure upstream component */
@@ -225,9 +229,15 @@ static void
pcie_aspm_configure_common_clock(struct pcie_link_state *link)
                reg16 |= PCI_EXP_LNKCTL_CCC;
        else
                reg16 &= ~PCI_EXP_LNKCTL_CCC;
-       pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+       if (reg16 != parent_reg) {
+               retrain = true;
+               pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+       }

        /* Retrain link */
+       if (!retrain)
+               return;
+
        reg16 |= PCI_EXP_LNKCTL_RL;
        pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);

@@ -436,13 +446,16 @@ static void pcie_aspm_cap_init(struct
pcie_link_state *link, int blacklist)

 static void pcie_config_aspm_dev(struct pci_dev *pdev, u32 val)
 {
-       u16 reg16;
+       u16 reg16, orig_reg16;
        int pos = pci_pcie_cap(pdev);

        pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+       orig_reg16 = reg16;
        reg16 &= ~0x3;
        reg16 |= val;
-       pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
+
+       if (reg16 != orig_reg16)
+               pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
 }

 static void pcie_config_aspm_link(struct pcie_link_state *link, u32 state)


git status
# On branch master
# Your branch is behind 'origin/master' by 3856 commits, and can be
fast-forwarded.
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   drivers/pci/pcie/aspm.c
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	patch1
no changes added to commit (use "git add" and/or "git commit -a")
