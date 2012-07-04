Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2GDByS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 21:54:18 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:57285 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2GDByQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 21:54:16 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Topic: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Index: Ac1ZdICAdYwUKctERYa3qDPOlfZeVAALcRwAAAdRd/A=
Date: Wed, 4 Jul 2012 01:54:00 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D401ABBE@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
 <4FF3963E.2030804@google.com>
In-Reply-To: <4FF3963E.2030804@google.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-03_09:2012-07-03,2012-07-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207030306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for reviewing my patch.

> > +	while (1) {
> > +		prev_why =  pstore_get_reason_str(prev_reason);
> > +		if (!strncmp(entry->var.Data, prev_why, strlen(prev_why)))
> > +			break;
> > +		prev_reason++;
> > +	}
> 
> This loop should probably be hardened to cope with bad data.  The patch description and code below show intention to overwrite
> garbage data, but this loop will never exit on garbage data.

OK. I will remove infinite loop above.

> > +	switch (prev_reason) {
> > +	case KMSG_DUMP_PANIC:
> > +	case KMSG_DUMP_EMERG:
> > +		/* Never erase panic or emergency message */
> > +		break;
> > +	case KMSG_DUMP_OOPS:
> > +	case KMSG_DUMP_RESTART:
> > +	case KMSG_DUMP_HALT:
> > +	case KMSG_DUMP_POWEROFF:
> > +		/* Can erase if new one is error message */
> > +		if (new_reason <= KMSG_DUMP_EMERG)
> > +			is_erasable = 1;
> > +		break;
> > +	default:
> > +		/* Can erase unknown message */
> > +		is_erasable = 1;
> 
> It is probably safer to actually complain here at compile time if a reason is missing.  prev_reason is an enum though, so if all cases are
> accounted for and no default is specified, gcc should complain if a new KMSG_DUMP enum value is added to the codebase without
> considering this logic here.

It makes sense.
I will remove "default" and add all cases of "KMSG_DUMP_*". 
In latest linus-tree, KMSG_DUMP_UNDEF is added.
I will check how we should treat it.


> > +		if (!can_erase_entry(entry, reason)) {
> > +			/* return without writing new entry */
> > +			spin_unlock(&efivars->lock);
> > +			*id = part;
> > +			return ret;
> > +		}
> 
> I'm not sure how comfortable I am with the code duplication here.  Was using a flag not workable?

If efi_pstore doesn't write new entry, it should return with non-zero value.
I will update my patch by changing to "return -EEXIST " or so.

Also, I will fix typo you pointed out.

Thanks,

Seiji
