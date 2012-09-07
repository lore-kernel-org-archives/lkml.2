Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2IGDW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:22:57 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:40685 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2IGDWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:22:55 -0400
Subject: Re: [PATCH 3.6 1/2] target: remove pscsi_clear_cdb_lun
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <50490CE7.2020806@redhat.com>
References: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>
	 <1346944410-19850-2-git-send-email-pbonzini@redhat.com>
	 <1346957885.4162.509.camel@haakon2.linux-iscsi.org>
	 <50490CE7.2020806@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Sep 2012 20:22:53 -0700
Message-ID: <1346988173.4162.581.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 22:51 +0200, Paolo Bonzini wrote:
> Il 06/09/2012 20:58, Nicholas A. Bellinger ha scritto:
> > On Thu, 2012-09-06 at 17:13 +0200, Paolo Bonzini wrote:
> >> The purpose of this function is to clear a LUN set in the CDB, in case
> >> the initiator talking to us is speaking an old standards version.
> >> However, as things stand, pscsi_clear_cdb_lun has two problems.  It
> >> will "deceive" the guest by clearing the LUN bits on initial
> >> commands (INQUIRY, TEST UNIT READY, etc.); but then it will let the
> >> LUN bits through on reads, which will likely fail due to protection not
> >> being enabled.  Second, not all commands are properly filtered, in
> >> particular WRITE's WRPROTECT bits are cleared.
> >>
> >> This should be done by the fabric module rather than by PSCSI, if it
> >> knows such initiators may be lying around _and_ it can assume that its
> >> initiators do not really care about protection information.  Nuke it
> >> from PSCSI.
> >>
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >> ---
> > 
> > NAK.  This code was originally added to prevent certain pSCSI HBAs from
> > going bonkers when they got a legacy SCSI LUN ID encoded within the CDB
> > (eg: the fabric LUN ID) that's different from the physical SCSI LUN ID
> > on an Parallel SCSI bus.
> 
> I understood, but what's good in making INQUIRY work, if the HBA will
> equally go bonkers on the first actual I/O (READ/WRITE/VERIFY are all
> affected)?
> 

The original purpose of pscsi_clear_cdb_lun() is to clear byte 1 bit 0-5
for all incoming CDBs in SCSI-2 that did encode LUN ID into the CDB as a
work-around for (some) Parallel SCSI hardware that depends on this value
to function.

As modern SCSI-3 + SAS fabrics, et al have moved away from doing this
completely, thinking about this some more I would be OK with disabling
this by default for modern SCSI HW if the pSCSI device is reporting >=
SCSI-3 from se_subsystem_api->get_device_rev().

> This is something the LLDs or the fabric module should be doing.  But I
> guess it could be an attribute too.
> 

I think it's safe to disable this for modern SCSI hw, but lets keep it
around for pSCSI backend devices that are reporting SCSI-2 support and
below.

Care to respin..?  ;)

Thanks Paolo!

