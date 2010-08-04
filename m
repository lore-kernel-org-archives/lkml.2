Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab0HDOo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:44:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab0HDOo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTin8eVm=_pw_DgP2wJW9pE0LgugqfXJE8aVXiH6R@mail.gmail.com>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
	<1280887483-2979-2-git-send-email-wad@chromium.org>
	<20100804090049.GH5464@nb.net.home>
	<AANLkTin8eVm=_pw_DgP2wJW9pE0LgugqfXJE8aVXiH6R@mail.gmail.com>
Date: Wed, 4 Aug 2010 09:44:55 -0500
Message-ID: <AANLkTik=thmEH7b+wRGM=m9LA3kjmg-dZ_yv19-SotrM@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] genhd, efi: add efi partition metadata to 
	hd_structs
From: Will Drewry <wad@chromium.org>
To: Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 5:14 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, Aug 4, 2010 at 11:00, Karel Zak <kzak@redhat.com> wrote:
>> On Tue, Aug 03, 2010 at 09:04:42PM -0500, Will Drewry wrote:
>>> This change extends the partition_meta_info structure to
>>> support EFI GPT-specific metadata and ensures that data
>>> is copied in on partition scanning.
>>
>> Why do want to store GPT-specific data (efi_guid_t) to
>> partition_meta_info? I think it would be better to use label and uuid
>> in a generic format (e.g. string or u8 uuid[16]) -- then you don't
>> have to use things like union, disklabel specific code to compare
>> uuids, etc.  IMHO your current code is too complicated.
>
> I don't mind having the raw data and the type accessible. It might be
> useful for something we don't know about and it basically comes for
> free.

I'll bump out the uuid at least, but it might be worth keeping an
extended meta info option.  But it's a lot less work to ditch it, so
I'm happy enough either way.


> But the only thing we are really interested in is the UUID, which,
> like Tejun already suggested, we should probably store
> format-independent, and have it always accessible. That way, we would
> not need any type-specific parser, we just handle the normal DCE
> format.

I'll bump it out and make it the efi code generic-ify its uuid.  Out
of curiousity, were you and Tejun thinking of keeping it as a 36 byte
string or as the 16 byte packed value.  While less space efficient,
I'd prefer the u8[36] as it avoids dealing with versioning when
parsing the user-supplied string.  Instead, each partition type can
properly unparse its uuids according to what they expect.

Seem reasonable?

> I don't think we should support any of the labels anyway in root= and
> similar, because they never really worked reliably with duplicates,
> and just ask for trouble.

Agreed. I don't think labels make sense, but we may later want to
support partition types (as I mention in my other mail).
