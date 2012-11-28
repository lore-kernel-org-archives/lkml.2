Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab2K1HIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:08:31 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:58956 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2K1HI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:08:28 -0500
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config
 groups
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <50B4DA4E.3020900@linutronix.de>
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
	 <50B39921.6090308@linutronix.de> <xa1ty5hogv6j.fsf@mina86.com>
	 <50B3A1A0.2000607@linutronix.de> <xa1ttxscgsht.fsf@mina86.com>
	 <50B4DA4E.3020900@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Nov 2012 23:08:16 -0800
Message-ID: <1354086496.18984.16.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian & Co,

On Tue, 2012-11-27 at 16:20 +0100, Sebastian Andrzej Siewior wrote:
> On 11/26/2012 06:54 PM, Michal Nazarewicz wrote:
> > On Mon, Nov 26 2012, Sebastian Andrzej Siewior wrote:
> >> Wouldn't say that. It may adds complexity on another level. The target
> >> subsystem has the same problem with adding luns and there seems nothing
> >> wrong with having lun3 and 4 and leaving 0 and 1 unsued.
> >
> > That's not what Wikipedia claims though (from
> > <http://en.wikipedia.org/wiki/Logical_Unit_Number>):
> >
> > 	LUN 0: There is one LUN which is required to exist in every
> > 	target: zero. The logical unit with LUN zero is special in that
> > 	it must implement a few specific commands, most notably Report
> > 	LUNs, which is how an initiator can find out all the other LUNs
> > 	in the target. But LUN zero need not provide any other services,
> > 	such as a storage volume.
> >
> > That's why I proposed solution where one needs to have continuous
> > numbering of LUNs.  I'm not an expert on SCSI though.
> 
> Let me quote "4.6.4 Minimum LUN addressing requirements" of SAM4:
> 
> | All SCSI target devices shall support LUN 0 (i.e., 00000000
> | 00000000h) or the REPORT LUNS well-known logical unit. For SCSI
> | target devices that support the hierarchical addressing model the LUN
> | 0 or the REPORT LUNS well-known logical unit shall be the logical
> | unit that an application client addresses to determine
> | information about the SCSI target device and the logical units
> | contained within the SCSI target device.
> 
> Nab, I think not having LUN0 configured as long as REPORT LUNS says
> which luns are available is fine. Target seems to work on linux without
> it and SAM4 does no claim otherwise unless I miss interpret it. Any
> opinion on this from your side?
> 

So we use a special RAMDISK-MCP @ target_core_device.c:g_lun0_dev along
with a se_lun (located @ se_portal_group->tpg_virt_lun0) to always
service REPORT_LUNS to LUN=0, regardless of LUN=0 configfs fabric
endpoint layout.

Note this happens within target_core_device.c:transport_lookup_cmd_lun()
once no active se_node_acl->device_list[unpacked_lun] entry can be
located.

> >
> >> With the tcm gadget I get:
> >>
> >> |scsi 0:0:0:2: Direct-Access     LIO-ORG  RAMDISK-MCP      4.0  PQ: 0
> >> ANSI: 5
> >> |scsi 0:0:0:3: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0
> >> ANSI: 5
> >>
> >> You notice :2 and :3 instead :0 and :1. While should be there something
> >> wrong with this?
> >
> > It may be that it works on Linux but fails on some other systems (or
> > even older Linux kernels).  Like I've said, I'm not SCSI expert, so my
> > knowledge of it is (embarrassingly) minimal.
> 
> Sure but still. You limit the user to create lunX folders where X can
> be 0..255 for instance. If the user chooses not create lun0, why force
> him?
> 

It's certainly easier for the user if REPORT_LUNS always 'just works' to
LUN=0.

--nab


