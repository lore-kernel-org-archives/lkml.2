Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0IAVSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:18:38 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:15676 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0IAVSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:18:37 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: Memory allocation modifications in ibm_newemac driver
Thread-Topic: Memory allocation modifications in ibm_newemac driver
Thread-Index: ActKFh1163SqUHTiROCjSFgwjSee2wABD/h2
Date: Wed, 1 Sep 2010 21:18:36 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2FBE@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2F09@Mercury.usurf.usu.edu>
In-Reply-To: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2F09@Mercury.usurf.usu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found out what was causing the crash, but still am not there and could use some direction:

What was happening was that I was not allocating a new SKB to replace the one in the ring that was being passed up the stack.  I have remedied that and am now having another issue:

Once the ring index rolls over (it does so at 64) I start to lose packets because they are not being handled correctly (or do not contain the correct headers or something of that sort).  Here is a simple ping test showing what is happening:

64 bytes from 172.31.22.21: seq=29 ttl=128 time=10.826 ms
emac/plb/opb/ethernet@ef600900: PACKET: 54 0X1800 110 0XC04E6B80
emac/plb/opb/ethernet@ef600900: PACKET: 55 0X1800 110 0XC04E6EC0
emac/plb/opb/ethernet@ef600900: PACKET: 56 0X1800 98 0XC04E70C0
64 bytes from 172.31.22.21: seq=30 ttl=128 time=10.839 ms
emac/plb/opb/ethernet@ef600900: PACKET: 57 0X1800 110 0XC04E6580
emac/plb/opb/ethernet@ef600900: PACKET: 58 0X1800 98 0XC04E5B80
64 bytes from 172.31.22.21: seq=31 ttl=128 time=10.832 ms
emac/plb/opb/ethernet@ef600900: PACKET: 59 0X1800 219 0XC04E5740
emac/plb/opb/ethernet@ef600900: PACKET: 60 0X1800 249 0XC04E5000
emac/plb/opb/ethernet@ef600900: PACKET: 61 0X1800 92 0XC04E5340
emac/plb/opb/ethernet@ef600900: PACKET: 62 0X1800 98 0XC04E4A00
64 bytes from 172.31.22.21: seq=32 ttl=128 time=10.825 ms
emac/plb/opb/ethernet@ef600900: PACKET: 63 0X5800 92 0XC04E4E00
emac/plb/opb/ethernet@ef600900: PACKET: 0 0X1800 98 0XC04EF520
emac/plb/opb/ethernet@ef600900: PACKET: 1 0X1800 92 0XC04D8340
emac/plb/opb/ethernet@ef600900: PACKET: 2 0X1800 98 0XC04D8260
emac/plb/opb/ethernet@ef600900: PACKET: 3 0X1800 60 0XC04E7AA0
emac/plb/opb/ethernet@ef600900: PACKET: 4 0X1800 92 0XC04E74A0
emac/plb/opb/ethernet@ef600900: PACKET: 5 0X1800 92 0XC04E6BC0
emac/plb/opb/ethernet@ef600900: PACKET: 6 0X1800 98 0XC04E6F80
emac/plb/opb/ethernet@ef600900: PACKET: 7 0X1800 92 0XC04E64E0
emac/plb/opb/ethernet@ef600900: PACKET: 8 0X1800 98 0XC04E5BC0

The first number in my debug print statement is what the driver calls the slot number (the ring index).  When it rolls over I start losing the ping replies.  What have I done wrong to cause that?  The data is coming in and is there.  Have any other network device developers seen similar behavior?

Thanks,

Jonathan

