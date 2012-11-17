Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2KQAej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:34:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41559 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2KQAef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:34:35 -0500
MIME-Version: 1.0
In-Reply-To: <20121117002753.GA22778@kroah.com>
References: <20121117002016.GA13493@www.outflux.net>
	<20121117002753.GA22778@kroah.com>
Date: Fri, 16 Nov 2012 16:34:34 -0800
X-Google-Sender-Auth: WZbaE8-4w0pM2xS1Kc6iGU_GXCk
Message-ID: <CAGXu5jJwFzuZgzSx6cQuAok=1uiXHa=B5BNaWGNn-fPa_uL3rA@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: mount with noexec and nosuid
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        ellyjones@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 4:27 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 16, 2012 at 04:20:16PM -0800, Kees Cook wrote:
>> Since devtmpfs is writable, make the default noexec nosuid as well. This
>> protects from the case of a privileged process having an arbitrary file
>> write flaw and an argumentless arbitrary execution (i.e. it would lack
>> the ability to run "mount -o remount,exec,suid /dev"), with a system
>> that already has nosuid,noexec on all other writable mounts.
>>
>> Cc: ellyjones@chromium.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/base/devtmpfs.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Have you tested this to verify that it doesn't break anything?

It doesn't break Chrome OS nor my test VM. The logic for building
/etc/mtab needs updating (it doesn't show nosuid,noexec), but
/proc/mounts reports it correctly.

-Kees

>
> Kay, could this cause any problems that you could think of?
>
> thanks,
>
> greg k-h
>
>>
>> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
>> index 147d1a4..b7e2e57 100644
>> --- a/drivers/base/devtmpfs.c
>> +++ b/drivers/base/devtmpfs.c
>> @@ -340,6 +340,7 @@ static int handle_remove(const char *nodename, struct device *dev)
>>  int devtmpfs_mount(const char *mntdir)
>>  {
>>       int err;
>> +     int mflags = MS_SILENT | MS_NOEXEC | MS_NOSUID;
>>
>>       if (!mount_dev)
>>               return 0;
>> @@ -347,7 +348,7 @@ int devtmpfs_mount(const char *mntdir)
>>       if (!thread)
>>               return 0;
>>
>> -     err = sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", MS_SILENT, NULL);
>> +     err = sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", mflags, NULL);
>>       if (err)
>>               printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
>>       else
>> @@ -368,11 +369,12 @@ static int handle(const char *name, umode_t mode, struct device *dev)
>>  static int devtmpfsd(void *p)
>>  {
>>       char options[] = "mode=0755";
>> +     int mflags = MS_SILENT | MS_NOEXEC | MS_NOSUID;
>>       int *err = p;
>>       *err = sys_unshare(CLONE_NEWNS);
>>       if (*err)
>>               goto out;
>> -     *err = sys_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, options);
>> +     *err = sys_mount("devtmpfs", "/", "devtmpfs", mflags, options);
>>       if (*err)
>>               goto out;
>>       sys_chdir("/.."); /* will traverse into overmounted root */
>> --
>> 1.7.9.5
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
