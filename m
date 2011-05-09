Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1EIPTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:19:48 -0400
Received: from mail.pre-sense.de ([213.238.39.107]:58521 "EHLO
	mail.pre-sense.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1EIPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:19:47 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 May 2011 11:19:47 EDT
Message-ID: <4DC804A0.4090404@pre-sense.de>
Date: Mon, 09 May 2011 17:13:36 +0200
From: Timo Warns <warns@pre-sense.de>
Organization: PRESENSE Technologies GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>, Richard Russon <rich@flatcap.org>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Harvey Harrison <harvey.harrison@gmail.com>, Greg KH <gregkh@suse.de>
Subject: Re: [Stable-review] [patch 35/38] fs/partitions/ldm.c: fix oops caused
 by corrupted partition table
References: <20110506001210.724927797@clark.kroah.org> <1304735051.3203.87.camel@localhost>
In-Reply-To: <1304735051.3203.87.camel@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------060007000202020003050207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060007000202020003050207
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Am 07.05.2011 04:24, schrieb Ben Hutchings:
> On Thu, 2011-05-05 at 17:11 -0700, Greg KH wrote:
>> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>>
>> From: Timo Warns <Warns@pre-sense.de>
>>
>> commit c340b1d640001c8c9ecff74f68fd90422ae2448a upstream.
>> [...]
> 
> I don't think this actually fixes the vulnerability, and I don't think
> this code works at all.
>
> [...]
>
>> +	if (rec >= num) {
>> +		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
>> +		return false;
>> +	}
> 
> This is fine for the first fragment we find, when we allocate memory
> based on 'num'.  However, when we add another fragment, we need to
> compare with f->num.  So there still seems to be the possibility of a
> buffer overflow.

Yes, I agree. I have missed this one. Please consider the attached patch.

>> [...]
>>  	memcpy (f->data+rec*(size-VBLK_SIZE_HEAD)+VBLK_SIZE_HEAD, data, size);
>>
>>  	return true;
> 
> The offset used for the destination means that the first VBLK_SIZE_HEAD
> bytes of f->data are never initialised!
> 
> I suspect (without any knowledge of LDM) that the intent was to use the
> header from the first fragment and drop it from the subsequent
> fragments, like this:
> 
> 	if (rec == 0)
> 		memcpy(f->data, data, VBLK_SIZE_HEAD);
> 	data += VBLK_SIZE_HEAD;
> 	size -= VBLK_SIZE_HEAD;
> 	memcpy(f->data + VBLK_SIZE_HEAD + rec * size, data, size);

The patch that I provided preserves the original behaviour. Hence, I
would like to pass this issue to Richard. Richard, could you comment on
this?

Cheers, Timo

--------------060007000202020003050207
Content-Type: text/x-patch;
 name="patch.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="patch.diff"

--- linux-2.6.38.5-b/fs/partitions/ldm.c	2011-05-02 18:30:53.000000000 +0=
200
+++ linux-2.6.38.5-a/fs/partitions/ldm.c	2011-05-09 17:09:07.000000000 +0=
200
@@ -1299,6 +1299,11 @@
=20
 	BUG_ON (!data || !frags);
=20
+	if (size < 2 * VBLK_SIZE_HEAD) {
+		ldm_error("Value of size is to small.");
+		return false;
+	}
+=09
 	group =3D get_unaligned_be32(data + 0x08);
 	rec   =3D get_unaligned_be16(data + 0x0C);
 	num   =3D get_unaligned_be16(data + 0x0E);
@@ -1326,6 +1331,12 @@
=20
 	list_add_tail (&f->list, frags);
 found:
+	if (rec >=3D f->num) {
+		ldm_error ("REC value (%d) exceeds NUM value (%d)", rec, f->num);
+		f->map &=3D 0x7F;			/* Mark the group as broken */
+		return false;
+	}
+
 	if (f->map & (1 << rec)) {
 		ldm_error ("Duplicate VBLK, part %d.", rec);
 		f->map &=3D 0x7F;			/* Mark the group as broken */
@@ -1334,10 +1345,9 @@
=20
 	f->map |=3D (1 << rec);
=20
-	if (num > 0) {
-		data +=3D VBLK_SIZE_HEAD;
-		size -=3D VBLK_SIZE_HEAD;
-	}
+	data +=3D VBLK_SIZE_HEAD;
+	size -=3D VBLK_SIZE_HEAD;
+
 	memcpy (f->data+rec*(size-VBLK_SIZE_HEAD)+VBLK_SIZE_HEAD, data, size);
=20
 	return true;

--------------060007000202020003050207--
