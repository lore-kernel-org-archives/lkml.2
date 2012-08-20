Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2HTU4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:56:37 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:55418 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab2HTU4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:56:35 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v2 2/3] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Topic: [RFC][PATCH v2 2/3] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Index: AQHNfxDPH9QP+hN7VkKgenHGKmL7MJdjLJ+g
Date: Mon, 20 Aug 2012 20:56:21 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413805E24@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C42@USINDEM103.corp.hds.com>
 <CAGTjWtBXCWi+gHJHO+_CO7mbTaruS0E2NfDCYPEY4gW2hBK9aA@mail.gmail.com>
In-Reply-To: <CAGTjWtBXCWi+gHJHO+_CO7mbTaruS0E2NfDCYPEY4gW2hBK9aA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-20_04:2012-08-20,2012-08-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208200256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > +static void delete_sysfs_entry(void)
> > +{
> > +       struct efivars *efivars = &__efivars;
> > +       struct efivar_entry *entry, *n;
> > +       efi_status_t status;
> > +       unsigned long flags;
> > +
> > +       list_for_each_entry_safe(entry, n, &efivars->list, list) {
> 
> This ->lock here is protecting this list, so it isn't correct to grab the lock within iteration.  The lock should instead be grabbed before
> iterating through the list, dropped if we need to unregister and iteration should restart completely if the lock was dropped.
> 

Thank you for your comment.
If my understanding is correct, the code should be changed as follows.

+       while (1) {
+               found = NULL;
+               spin_lock_irqsave(&efivars->lock, flags);
+               list_for_each_entry(entry, &efivars->list, list) {
+                       status = get_var_data_locked(efivars, &entry->var);
+                       if (status != EFI_SUCCESS) {
+                               found = entry;
+                               list_del(&entry->list);
+                               break;
+                       }
+               }
+               spin_unlock_irqrestore(&efivars->lock, flags);
+               if (found)
+                       efivar_unregister(entry);
+               else
+                       break;
+       }

> > +               spin_lock_irqsave(&efivars->lock, flags);
> > +               status = get_var_data_locked(efivars, &entry->var);
> > +               if (status != EFI_SUCCESS) {
> > +                       list_del(&entry->list);
> > +                       spin_unlock_irqrestore(&efivars->lock, flags);
> > +                       efivar_unregister(entry);
> > +               } else
> > +                       spin_unlock_irqrestore(&efivars->lock, flags);
> > +       }
> > +}
> > +       /* Delete unavailable sysfs entries */
> > +       delete_sysfs_entry();
> 
> This method needs a better name that reflects what it is doing.
> delete_all_stale_sysfs_entries ?

OK. I will change the name to it.

Seiji

