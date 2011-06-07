Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1FGUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:16:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:37815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1FGUQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:16:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="10773063"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>
Date: Tue, 7 Jun 2011 13:16:55 -0700
Subject: RE: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Topic: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Index: AcwlPxAEVSw7LWLiQTCci5nyAA4sNwAAFZ3Q
Message-ID: <987664A83D2D224EAE907B061CE93D5301E70D8EAE@orsmsx505.amr.corp.intel.com>
References: <1307470562-15633-1-git-send-email-mjg@redhat.com>
 <1307470562-15633-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1307470562-15633-4-git-send-email-mjg@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efi_pstore_info.buf) {
+		efi_pstore_info.bufsize = 1024;
+		efi_pstore_info.data = efivars;
+		mutex_init(&efi_pstore_info.buf_mutex);
+		pstore_register(&efi_pstore_info);
+	}

I'd imagined #ifdef CONFIG_PSTORE around this (and the
efi_pstore_info definition) rather than providing stubs
for the !PSTORE case.

But your way works too.

You should avoid a memory leak with:

		if (!pstore_register(&efi_pstore_info))
			kfree(efi_pstore_info.buf);


I've also been thinking some more about how to handle a
system that has more than one pstore back-end available.
I still don't have any good ideas how to make use of more
than one backend - but it occurs to me that we may need
a way to let the user choose which to use (e.g. in the
unlikely event that a BIOS bug made one of ERST or EFI
unusable by pstore). The current "whoever registers first
gets to use it" now seems inadequate.

Perhaps a command line "pstore={backend}" might work, so
the user could specify pstore=efi to get your code, and
pstore=erst to get mine.

	
-Tony
