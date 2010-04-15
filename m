Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0DOL7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:59:00 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:41356 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752282Ab0DOL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:58:57 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 8nG9YNEVM1mn.BgA3fV1N_ygdTwL8US1DlyeK6vJRdVqOP67cE1SWFKAj7azsZeKqd1qJSmlR4fJwLrVmSUNZAdPwECrDyC4TF7jZK6nu.aEy0W1Hs5UiFfW73qXPasgkZJvJ0IC0_3bezAlReW6LIxuaUu3b7Vqc4iwS9n9ZAaYTxWdI1R_juhO8V4fdLw5zzy2LURsbbTQhYJqFsaFRuhMbW_yhxewK0C3d584egzySbzZnzttx7p8l4v9dMLABN7nxWUPqApvwU1NOxTkMgBBsc2Va2YI96LB_7BuhNiid5o-
X-Yahoo-Newman-Property: ymail-3
Subject: TCM_Loop virtual SAS Ports + megasas HBA emulation into Linux
	Guests
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Gerd Hoffmann <kraxel@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@suse.de>,
       Douglas Gilbert <dgilbert@interlog.com>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain
Date: Thu, 15 Apr 2010 04:58:47 -0700
Message-Id: <1271332727.3082.70.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Hannes, Christoph and Co,

So after some additional discussions on and off the linux-scsi list wrt
to KVM + megasas emulation, I got motivated and decided to try it out
for myself using the QEMU code from Gerd's tree at:

http://repo.or.cz/w/qemu/kraxel.git branch: scsi.v9.

As expected using megasas with hw/scsi-disk.c for QEMU userspace CDB
emulation is working, Thank you Dr. Hannes! :-)

Sooo, after poking around a bit further I managed to (partially) get the
TCM_Loop fabric module running with Persistent Reservation and ALUA
using virtual target SAS ports with megasas via hw/scsi-generic.c.  I am
using a single TCM/IBLOCK backstore (single SATA JBOD disk) with two
virtual SAS target ports appearing as local drives on the Linux host.

>From there I am using the following CLI ops to start two qemu instances:

./x86_64-softmmu/qemu-system-x86_64 -m 2048 -smp 4 /root/lenny64guest0-orig.img  \
  -drive if=none,id=mydisk,file=/dev/sg3 -device megasas,id=raid  \
  -device scsi-generic,bus=raid.0,scsi-id=1,drive=mydisk

Here are some observations of what I have seen with various tests so
far..

*) By representing one TCM/IBLOCK backstore as two virtual SAS target
ports, I can pass each scsi-generic device (representing the same
underlying struct block_device) from TCM_Loop's LLD into different Linux
guests.

*) Most TCM control path CDB emulation is working as expected.  This
includes Persitent Reservation IN CDBs and implict ALUA access state
transitions using sg_rtpg to virtual SAS ports in Linux guests..!

*) DATA_SG_IO READs (and I assume WRITEs as well) via hw/scsi-generic.c
are failing in Linux guests with the following message:

scsi_command_complete: ret -90 (Message too long)
[raid.0 id=1 lun=0] READ_12 - from-dev len=4096
scsi_command_complete: ret -90 (Message too long)
[raid.0 id=1 lun=0] READ_12 - from-dev len=512

I assume this is because megasas is currently using hw/scsi-disk.c, yes?

*) Persistent Reservation OUT CDBs seem to be getting dropped with GOOD
status, but the same PR OUT op is still working as expected when using
the virtual SCSI device on the Linux Host.  This does appear to be
specific to PROUT with megasas AFAICT..

Here is the very first screen shot of TCM_Loop + megasas in action on
host running a fresh cut of v2.6.34-rc4:

https://www.linux-iscsi.org/images/TCM_Loop-megasas-04152010.png

I will keep poking around and add the WIP items + info to the KVM and
TCM_loop pages on the LIO wiki.  Until then, any comments to steer me in
the right direction to address the above items would be apperciated.

Best,

--nab









