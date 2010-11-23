Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0KWXne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:43:34 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39486 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab0KWXnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:43:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qJbkVIRZuOEYiqc6OZz69SeUf4fzdMEcFMwi2LqRALPSWcvdZOPcoAkXrOxaXhZJQF
         Nr8vqDOf9SX8KOGX6OC0CiOswFqrIhVkNmvrxum2irTuBvkUrNm8bpPBXk8OEB9oB2ma
         ix7+l28GOwuYTo5rt8+AOFGa8hw93c13dQHK0=
MIME-Version: 1.0
Date: Wed, 24 Nov 2010 00:43:32 +0100
Message-ID: <AANLkTinzepKLh+x7VwaqCMdue28y0xUhXFqnvZ19d5-f@mail.gmail.com>
Subject: Fanotify uid leak?
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Eugene Teo <eugene@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2010 00:25, Eric Paris <eparis@redhat.com> wrote:
> On Wed, 2010-11-24 at 00:15 +0100, Vegard Nossum wrote:
>> Hi,
>>
>> Inotify does not clean up properly when it fails to create the file
>> descriptor. So it leaks kernel memory. Watch "slabtop" while running
>> this program:
>>
>> #include <sys/inotify.h>
>> #include <unistd.h>
>
> potential patch at
> http://git.infradead.org/users/eparis/notify.git/shortlog/refs/heads/for-next
>
> Only compiled, not tested.  Will try to do that after dinner!

There is, by the way, I think, another problem in fanotify_init(),
fs/notify/fanotify/fanotify_user.c:

        user = get_current_user();
        if (atomic_read(&user->fanotify_listeners) >
FANOTIFY_DEFAULT_MAX_LISTENERS) {
                free_uid(user);
                return -EMFILE;
        }

[...]

        /* fsnotify_alloc_group takes a ref.  Dropped in fanotify_release */
        group = fsnotify_alloc_group(&fanotify_fsnotify_ops);
        if (IS_ERR(group))
                return PTR_ERR(group);

so you see if the group allocation fails, then the uid will not be
freed. Please double check.

This is in any case too hard for me to trigger as it would only happen
when memory allocation for the group fails.

Enjoy your meal :-)


Vegard
