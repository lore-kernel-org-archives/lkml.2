Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031120Ab2CVVw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965161Ab2CVVwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:52:24 -0400
Date: Thu, 22 Mar 2012 17:52:11 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: device-mapper development <dm-devel@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Elly Jones <ellyjones@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: remake of the verity target
In-Reply-To: <20120322174101.GM27051@google.com>
Message-ID: <Pine.LNX.4.64.1203221739060.11979@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
 <20120306215947.GB27051@google.com> <Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
 <20120320154159.GD27051@google.com> <Pine.LNX.4.64.1203202045150.23255@file.rdu.redhat.com>
 <Pine.LNX.4.64.1203202233250.6371@file.rdu.redhat.com>
 <CACBanvrjZbDY+aUUyp9-YuG8KoEd9k-cn50kn8N=3DQxKf7QFA@mail.gmail.com>
 <Pine.LNX.4.64.1203202340160.15617@file.rdu.redhat.com>
 <CACBanvqYb3MU=Zy7HNJ2oMekQE6FZY5ZtN7QAaAv0M=tVH=cXw@mail.gmail.com>
 <Pine.LNX.4.64.1203211304550.7011@file.rdu.redhat.com> <20120322174101.GM27051@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Mar 2012, Mandeep Singh Baines wrote:

> Mikulas Patocka (mpatocka@redhat.com) wrote:
> > 
> > This is improved patch that supports both the old format and the new 
> > format. I checked that it is interoperable with with the old Google 
> > userspace tool and with the original Google kernel driver.
> > 
> 
> Thanks much for doing this:)
> 
> This looks good but would a prepend/append flag be better?

It does more than changing prepend/append salt. I changed alignment in the 
new format so that it doesn't have to use a multiply instruction.

In the old format, if digest size is not a power of two, all digests are 
placed first and the rest of the block is padded with zeros. In the new 
format, each digest is padded with zeros to a power of two.

For example, when using sha1, the old format padding looks like this:
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccccccdddddddd
dddddddddddddddddddddddddddddddd00000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000

... and the new format padding looks like this:
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
cccccccccccccccccccccccccccccccccccccccc000000000000000000000000
dddddddddddddddddddddddddddddddddddddddd000000000000000000000000

The version "0" (first argument in the target line) actually means the old 
style padding and the salt is hashed after the data. The version "1" means 
new style padding and the salt is hashed before the data. If someone comes 
with another format, we can use version "2" for it, etc.

Mikulas
