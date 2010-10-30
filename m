Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205Ab0J3Ay1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:54:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0J3Ay0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D1PjhYqballbxYXHN1DYJY1jm+1tqrYniQLxXiUVMIIli/AMhGh4M/E2x1joUQZeyz
         6pIWc/PiHAKsTLoBc65bkWscJjc4Ovs918PpFHA5BC45jEk4QeU53/qQnFaN07wOjXRS
         fBIie7IHKndFRpPF8KkDAdsbDgeIAyFTEonmw=
MIME-Version: 1.0
In-Reply-To: <20101030003357.029b4e02@werewolf.home>
References: <20101022013544.0fdab0e0@werewolf.home>
	<4CC16B1E.4060709@suse.de>
	<20101023004636.1acdd81c@werewolf.home>
	<20101024013038.057442c0@werewolf.home>
	<4CC55894.5040509@suse.de>
	<20101030003357.029b4e02@werewolf.home>
Date: Fri, 29 Oct 2010 19:54:24 -0500
Message-ID: <AANLkTin-tXH-Q5wDGs9ZCQGdEZkm7w=AEdegDjV0mn6S@mail.gmail.com>
Subject: Re: CIFS is slooow, gvfs is fast
From: Steve French <smfrench@gmail.com>
To: =?ISO-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 5:33 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> On Mon, 25 Oct 2010 15:44:44 +0530, Suresh Jayaraman <sjayaraman@suse.de> wrote:
>
>> On 10/24/2010 05:00 AM, J.A. Magallón wrote:
>> > On Sat, 23 Oct 2010 00:46:36 +0200, "J.A. Magall�n" <jamagallon@ono.com> wrote:
>> >
>> >>
>> >> If you mean hardware network path (cabling, router), yes.
>> >> For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mount
>> >> point on '~/.gvfs/media on htpc'.
>> >>
>> >> And here comes the weird part. To rule out the desktop environment factor,
>> >> I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
>> >> ~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything...
>> >> things get reversed depending if you use a gui or commandline.
>> >>update
>> >> Weird, really weird...
>> >>
>> >
>> > Well, to sort things out, I did some more tests (this does not mean things
>> > get any closer to be clear for me at least...).
>> >
>> > Can anybody tell me whats going here...??
>> > It looks just like gui tools behave just in reverse of cli, and that a plain
>> > smbclient is faster that cifs. I'm really confused...
>> >
>>
>> Could you try mounting from commandline with something like
>>   `mount -t cifs //server/share /mnt/point -o user=user1`
>> (commenting out the fstab entry) and try copying the file?
>>
>>
>
> Same results, cli copy takes about 7.5 seconds (thats around 40MB/s), and
> gui copy says it runs at 7.8 MB/s.
> This could be the normal behaviour I could expect, gui is slower as it has to
> update progress bars, move flying sheets, or even does a sync from time to
> time.
>
> The misbehaviour I see is the other way aroung, FUSE/GVFS is fast from GUI
> and slow from CLI. And, the best, why are there any difference ???

The obvious thing to check is actual cifs write sizes on the network
(with wireshark e.g.)
and how much parallelism.   We know cifs kernel client will send 56K
writes, but only one at
a time for any particular file.  (thanks to Pavel the smb2 kernel
client will send more
in parallel and get about two to three times better performance).   cifs kernel
client can send less than 56K if the dirty pages are scattered of course
(writepages won't be called with contiguous dirty pages) and cifs client can
send more than 56K when mounting with "directio" cifs mount option
but only if the application tries to write more than 56K for each user space
write operation (mounting with directio might be a nice comparison point).


-- 
Thanks,

Steve
