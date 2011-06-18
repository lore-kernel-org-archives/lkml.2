Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab1FRRnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:43:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44323 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1FRRnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SRfb0Lj2bJEVC2/1lvsV7A9saX9VmYOALLNbobPDh4PT3sitK43AVf9QZmQrHI1CLj
         c5MswC1qfqtXlhB7K09sHAV/7ign0eRWLhlGBzalf0jUBp3cixABGyb3MSnyqOZQMtQ8
         eTD6LDWsL7e3KKD/FMYg1jvCp46CQxwHAFmAw=
Subject: Re: Does Linux select() violate POSIX?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nemo Publius <nemo@self-evident.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Jun 2011 19:43:05 +0200
Message-ID: <1308418985.3539.58.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 18 juin 2011 à 10:06 -0700, Nemo Publius a écrit :
> Suppose I  have a file descriptor referencing a TCP/IP socket in blocking mode.
> 
> Suppose select() reports that the descriptor is ready for reading.
> 
> If I then call recv() on that descriptor, can it _ever_ block?
> 
> 
> According to the Linux select man page
> (http://linux.die.net/man/2/select), the answer is yes:
> 
> "Under Linux, select() may report a socket file descriptor as "ready
> for reading", while nevertheless a subsequent read blocks. This could
> for example happen when data has arrived but upon examination has
> wrong checksum and is discarded. There may be other circumstances in
> which a file descriptor is spuriously reported as ready."
> 

Only UDP can currently do that, not TCP, if NIC did not already verified
the checksum.

So the answer to your question is no.

> 
> According to the POSIX specification for select
> (http://pubs.opengroup.org/onlinepubs/9699919799/functions/select.html),
> the answer is no:
> 
> "A descriptor shall be considered ready for reading when a call to an
> input function with O_NONBLOCK clear would not block, whether or not
> the function would transfer data successfully. (The function might
> return data, an end-of-file indication, or an error other than one
> indicating that it is blocked, and in each of these cases the
> descriptor shall be considered ready for reading.)"
> 
> 
> There are only three possibilities:
> 
> 1) I am mis-reading the POSIX spec.
> 2) The Linux select() man page is wrong.
> 3) Linux select() violates the POSIX spec.

We dont care, since every sane application using select() should also
use socket in non blocking mode.

Between time select()/poll() says 'OK you can go', and time you enter
kernel, conditions might have changed. For example, maybe kernel memory
is not available and a send() would _block_, even if socket queue is
empty.



