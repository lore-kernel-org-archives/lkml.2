Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0LIAQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:16:12 -0500
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:31243 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753982Ab0LIAQI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:16:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=QDxl8gYYQAB6rs0qwQ9XP+8uaLBjY/5qQj20VYpkd1hlWCJnhmHbu7Yz9Sl1/bB4J7uldq0aZfBbfEbnni3wNptieQYPgUR/BElJzyqWgvif9GuzqpYONeEr3vcfdST6eJmE0gOxOe7yxB1nKg0NBBZQOx1tLfAFJSeJJJtTlp4=;
Message-ID: <233716.61101.qm@web31813.mail.mud.yahoo.com>
X-YMail-OSG: M3egIpkVM1ktiDRraqhah8h4e5C.xQVy2bgDdebchT889tW
 Q9c0UsPgihQZI2A1we0GmYdLaY_KnFjQJHeg71aVlEUp7Emh2aHMIfhmF7gw
 9VslwbQPCiuJvDPauEKbN10AD9MhiE2hB.x1cyL2A.SK5oOUzUnWVxwwXkJ9
 6aEZJMcu_AsTgWxd_a7og9Dnf1hhPTNNh2g3nJs1jEQgp0t1cQoxZPOLsDUP
 Dqe8gJBhZeTPUb3m1ntllFoaqo7xBwK9eGRTyZmUJo3UZmHT0r7MsbCwfteM
 wV3TsbVBqpGBfsrq8K9FxAU3hEQ7CG9zA7GW8z7W8avq_MB_UPHcaaBQoZ.S
 GYyhOK3BL3fesedCZ8g--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Wed, 8 Dec 2010 16:16:06 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/6/10, Greg KH <greg@kroah.com> wrote:
>
> We already have this support in the kernel tree,

Greg, this isn't an effort for "linux kernel code turf".  This is a well-implemented driver according to the respective specifications (SAM, SPC, USB 2/3). It reflects correct implementation, naming, etc. It shows understanding of the abstraction layers and underlying technology. It's what you'd want to have in /YOUR/ kernel.

> why do you want and need another driver that does the same exact thing?

Nothing can be further from the truth. The current uas.c driver doesn't do the "exact same thing", far from it.

You responded 4 minutes after my post. Did you have to time to verify that the driver I posted does "the exact same thing" as the one in the kernel?

"The exact same thing", let's see:
1) uasp.c doesn't assume the alternate setting of the interface and discovers its setting. uas.c assumes it's 1.

2) uas.c doesn't do any error checking of the endpoints, and goes ahead
and registers a scsi host first, and then "configures" the endpoints, while end point configuration/discovery may fail or be incorrect.

3) uasp.c correctly parses the pipe usage endpoint descriptors and
saves them in a target port abstraction. If any were not present, discovery of the device fails. 

4) uasp.c discovers the maximum number of streams we can use of the streaming endpoints (their minimum) of the interface, uasp blindly requests 256.

5) uasp.c fails discovery if no streaming is supported (bad configuration) for a SuperSpeed device. uas.c doesn't do any checking and doesn't discern between SS and HS (it relies on usb_alloc_streams() to fail, thus it cannot discover the correct/valid number of streams of the target interface).

6) uasp.c correctly sets the number of commands the block/SCSI layer can enqueue, reserving tags for TMF and untagged commands. uas.c has no concept of TMFs and doesn't do this.

7) uas.c incorrectly sets some members of shost. uasp.c does this correctly.

8) uas.c is filled with incorrect comments showing the unfamiliarity of the author(s) with SAM, SPC, USB, etc. For example,

SCSI:
> .can_queue = 65536,    /* Is there a limit on the _host_ ? */

Unfamiliarity with USB or SAM or both:
> /* XXX: Can we reset just the one USB interface?
>  * Would calling usb_set_interface() have the right effect?
>  */
and
> /* XXX: Need to return 1 if it's not our device in error handling */

Unfamiliarity with UAS/SS (scary commend follows, read at your own risk):
> /*
>  * Why should I request the Status IU before sending the Command IU? Spec
>  * says to, but also says the device may receive them in any order.  Seems
> * daft to me.
> */

Unfamiliarity with SAM, SCSI, etc: the driver trying to re-queue
failed Execute Command procedure with the transport. The driver abusing SCSI_MLQUEUE_DEVICE_BUSY and its usage of a work queue to both requeue URBs and data (wrong in transport protocol driver).  These result in infinite loops in SCSI/block layer when the device goes out to lunch (I can test quite a few possibilities), or errors out, or errors out in the middle of a HighSpeed transaction requiring RRDY and WRDY.

9) uasp.c provides correct (extensible) abstraction of underlying (represented) objects (Target port, LU and command, a la I_T_L_Q nexus). uas.c lacks this.

10) uasp.c implements TMF for both SS and HS modes of operation (directly related to 9 above.) uas.c cannot do this as it has no representation of the I_T_L_Q nexus.

11) uasp.c provides correct naming of structs, constants, etc. It is what you want in a protocol driver. uas.c lacks this.

12) uasp.c does NOT implement packed structs to represent the information units, nor does it use be_to_cpu[p]() and cpu_to_be() to read/write values from said units. It is a portability nightmare (alignment, flexibility, etc). Instead uasp.c uses byte access, shift and or logical operations to extract values from the information units.  uas.c does implement packed structs, and does use be_to_cpu[p]() and cpu_to_be(), again a portability nightmare.

13) uas.c uses infantile non-value comments like:
> /* I hate forward declarations, but I actually have a loop */

14) uasp.c correctly uses dev_dbg()/dev_err()/dev_info()/etc, to report interesting information at each level of debugging. Thus it supports dynamic debugging.

15) uasp.c correctly implements the protocol and doesn't allow for non-conforming devices to be used (which are by default NON-UAS), such as devices that don't implement the required pipes, or early (out of protocol) information units. Such devices should never see the light of day, as they will cause interoperability problems. Dynamic ids are also supported by uasp.c.

16) uasp.c implement a module parameter limiting the number of streams to request from XHCI HCD to allocate. This is due to the fact that some HC misreport the number of streams they support by a factor of two since they filled in the HCCPARAMS field MaxPSASize. That is, they solved 2^v = streams, instead of 2^(v+1) = streams. Of course when the device tries to send back status, the host says ACK(NumP=0) and the device goes into flow control... etc. This module parameter allows to limit the streams allocated.

17) uasp.c implements correct tag assignment for TMFs such that should we get into 16 above, a TMF status _can_ be returned to the host. uas.c has no concept of TMFs to begin with.

18) uasp.c correctly checks the device configuration and fails discovery as it correctly reports that to USB.

There is perhaps more.

   Luben

