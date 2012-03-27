Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2C0NQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:16:25 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:41778 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab2C0NQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:16:23 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>
Date: Tue, 27 Mar 2012 15:15:57 +0200
Subject: Using remoteproc with ST-Ericsson modem. 
Thread-Topic: Using remoteproc with ST-Ericsson modem. 
Thread-Index: Ac0ITNcDEBP8qd3eRaq3xSQWtO9HEwDzKO1g
Message-ID: <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112091442.04294.arnd@arndb.de>
 <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
 <201203221657.09820.arnd@arndb.de>
In-Reply-To: <201203221657.09820.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BbCp E6df Figu MPRr W6jF eui5 io0B kLto mOnB nK8O qpHl
 sXIQ suvN u5Db wni3
 0JeF;5;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGwAaQBuAHUAcwAuAHcAYQBsAGwAZQBpAGoAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG8AaABhAGQAQAB3AGkAegBlAHIAeQAuAGMAbwBtADsAcwBqAHUAcgBiAHIAZQBuAEAAZwBtAGEAaQBsAC4AYwBvAG0A;Sosha1_v1;7;{1185281C-20B1-4CB5-9701-DC93D5791321};cwBqAHUAcgAuAGIAcgBhAG4AZABlAGwAYQBuAGQAQABzAHQAZQByAGkAYwBzAHMAbwBuAC4AYwBvAG0A;Tue,
 27 Mar 2012 13:15:57
 GMT;VQBzAGkAbgBnACAAcgBlAG0AbwB0AGUAcAByAG8AYwAgAHcAaQB0AGgAIABTAFQALQBFAHIAaQBjAHMAcwBvAG4AIABtAG8AZABlAG0ALgA=
x-cr-puzzleid: {1185281C-20B1-4CB5-9701-DC93D5791321}
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2RDGVjt022369

Hi Ohad,

[Arnd]
>Remoteproc and rpmsg are now in the arm-soc tree and will be merged
>upstream for v3.4, I suggest you discuss with Ohad how to best hook in
>there.

I would like to discuss with how to use remoteproc for the ST-Ericsson
modem. For a while, I have been working on a shared memory interface
for ST-Ericsson modems. I already have one version in linux-next, but
I'm planning on redoing parts of the implementation. As part of this, I
want to investigate if I can use remoteproc for handling the start-up
of our modem. One solution could be to make firmware and resource handling
pluggable.

The principles for remoteproc and modem_shm are not so different.
 a) We have a number of channels in shared memory, and the shm-address is
   predefined.
 b) Boot images are copied into shared memory before start.

However, we have a couple of requirements that are different.
- We don't use a ELF binary for resource definition. We have resource
  definitions in a binary format outside the binary. (I'm afraid I'm
  not able to change this).
- We need user-space to access sequential data streams.
- We use CAIF (a muxing protocol) implemented in the networking subsystem.

In order to use remoteproc, I think it could be a good idea to make the
firmware, resource and possible Virtio handling pluggable. E.g:

static struct rproc_ops rproc_ops = {
      ...
       .fw_sanity_check = fw_sanity_check,
       .fw_resource_handler = fw_resource_handler,
       .fw_load = fw_load,
       .fw_config_virtio = fw_config_virtio,
};

I think we need to be able to launch other Virtio device types than
VIRTIO_ID_RPMSG as well. Most likely, I need to make a CAIF specific
VIRTIO type due to the fact that I need RX direction to be reversed
(modem must be able to post it's payload buffer to Virtio ring).

[Sjur:]
>> For the stream interface it's tempting to reuse the ring buffer interface
>> to the modem from last time. But perhaps the Virtio-console could be as the
>> user-space interface...
[Arnd:]
>sounds doable, but again Ohad may have better suggestions as well.

We also define stream channels. As mentioned, I'm considering the possibility
of reusing Virtio console.

So, I'd really like to get your viewpoint and ideas for how we could use
remoteproc to manage the ST-Ericsson modem.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
