Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0KZLVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:21:21 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45406 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab0KZLVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlwyYObLhFeRsFFyk+URB63Wj07EBpP7HplzJcq9l9Zb1X4trzs0eXf/ZCuLwpa8fW
         mZhrxzwqiVtcWTMZZ8bbeST1l73AZAMgueIA39kjD3/GXbw3n6Pl4aYbWlArZrg+Fs1V
         0P4NVj7t5eg8oVcX/qWF5W6OMBx+O9Jkvh5HQ=
MIME-Version: 1.0
In-Reply-To: <201011261011.55266.tvrtko.ursulin@sophos.com>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
	<20101122003357.13674.30341.stgit@zaytsev.su>
	<201011261011.55266.tvrtko.ursulin@sophos.com>
Date: Fri, 26 Nov 2010 14:21:18 +0300
Message-ID: <AANLkTikRDyq4_rA5M7tiAuJJ7aa-pGfRj2YeqAmH5COA@mail.gmail.com>
Subject: Re: [PATCH 4/4] fanotify: Expose the file changes to the user
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Eric Paris <eparis@redhat.com>, Scott Hassan <hassan@dotfunk.com>,
        Jan Kara <jack@suse.cz>, "agruen@linbit.com" <agruen@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 13:11, Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> On Monday 22 Nov 2010 00:37:21 Alexey Zaytsev wrote:
>> +struct fanotify_opt_hdr {
>> +       __u8 type;
>> +       __u8 reserved;
>> +       __u16 len;
>> +       /* Payload goes here. */
>> +};
>> +
>> +#define FANOTIFY_METADATA_VERSION      3
>>
>>  struct fanotify_event_metadata {
>> -       __u16 event_len;
>> +       __u16 event_len; /* Including the options */
>>         __u8 vers;
>> -       __u8 reserved;
>> +       __u8 options_offset; /* Aka header length */
>>         __s32 fd;
>>         __aligned_u64 mask;
>>         __s32 pid;
>> +       /* Options go here. */
>>  };
>
> I am not 100% comfortable with having 16 bits length fields because I am just
> not sure there is a measurable performance difference versus just going with
> 32 bits.

I'm not concerned so much with the performance, as with the storage.
If we are generating events for every access on a mount point, some
consumers might build a considerable backlog over a period of high
activity. Would be good if we could cut the event size by 1/3 for
free. And I don't see an event growing 64k even with the options. Do
you?


>
> Also, options_offset is, if I understood it correctly, basically the lenght of
> fanotify_event_metadata. As such, isn't that field redundant since the lenght
> is implied from the protocol version?

There are two problems there.

1) You lose backwards-compatibility. It's still an ABI breakage, even
if you tell the users about it.

2) You can't build a program to account for different fanotify versions:
        if (vers >= N) { use the cool stuff } else if {vers >= N-1}  {
still good }
