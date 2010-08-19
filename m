Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0HSWtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:49:31 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:36797 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752861Ab0HSWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:49:30 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 6PgvB1gVM1lTSq9opY.6KL.2HreMy9o240M8AZnM09JZkIg
 UZIf5YJyHoSXnRTekTrZ42Ya6JO2pjktV6swYqcuqTw_dPR6nmqjOyXd3vTW
 OFRcKZzK83l3dNIJkOpF7NZAk74pVCUKNG.RlzcLB97r26_5XEP0VUdsHvV0
 zzoQQfKQlZ16axsn9rZuJnmh3ajbCe1cHRgeLMy.r619O2N6GGLbGtlfMI17
 C9hFEwYBFM2JanuUxJq3hdNql_x8U_zHzeWL4yQk1LJRcPagKwJotcIrcCH2
 tOiyBuvBso7t_rqgrE7B66D3Tl3.bWLfsMsiINdltWdVMKaRh3A9om_Zk
X-Yahoo-Newman-Property: ymail-3
Subject: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Hannes Reinecke <hare@suse.de>
Content-Type: text/plain
Date: Thu, 19 Aug 2010 15:45:47 -0700
Message-Id: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings mnc and tomo,

So as per our discussions last week, I will be moving forward with the
conversion of the LIO-Target iSCSI fabric module v4 to use protocol and
PDU include/scsi/iscsi_proto.h.  As mnc and I agreed privately, this is
going to the right level of integration for v2.6.37, as making libiscsi
target mode aware does not really make for a target mode iSCSI stack
sense due to the amount of logic in place for kernel <-> user with the
Open-iSCSI initiator.

So aside from the main tedious work that will be involved in actually
producing a patch for this on my end, I did notice one immediate item
that will cause an extra headache..  This involves the struct
iscsi_init_* and struct iscsi_target* structure definitions in:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/lio-target/iscsi_protocol.h;hb=refs/heads/lio-4.0

namely that they all have trailing 'u32 header_digest' member that a
decent amount of utility code in iscsi_target.c and iscsi_target_util.c
currently depends upon.

So, assuming that the conversion of all struct iscsi_init_* and struct
iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
checking structure size and renaming the member use in
drivers/target/lio-target, would it be acceptable to do something like:

/* iSCSI PDU Header */
struct iscsi_cmd {
        uint8_t opcode;
        uint8_t flags;
        __be16 rsvd2;
        uint8_t hlength;
        uint8_t dlength[3];
        uint8_t lun[8];
        itt_t    itt;   /* Initiator Task Tag */
        __be32 data_length;
        __be32 cmdsn;
        __be32 exp_statsn;
        uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
        /* Additional Data (Command Dependent) */
#ifdef ISCSI_TARGET_MODE
        __be32 header_digest;
#endif
};

for the existing PDU defs in iscsi_proto.h in order to the pain
of having to convert this over in existing LIO-Target fabric module
code..?  This really help me alot.

Thanks!

--nab


