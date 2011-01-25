Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1AYEhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 23:37:09 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:54314 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475Ab1AYEhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 23:37:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAHbiPU1Ld/sX/2dsb2JhbAAMhAfMRpBggSSDOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,372,1291611600"; 
   d="scan'208";a="89130810"
Message-ID: <4D3E5372.9010305@teksavvy.com>
Date: Mon, 24 Jan 2011 23:37:06 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <20110124175456.GA17855@core.coreip.homeip.net> <4D3E1A08.5060303@teksavvy.com> <20110125005555.GA18338@core.coreip.homeip.net> <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net>
In-Reply-To: <20110125042016.GA7850@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-24 11:20 PM, Dmitry Torokhov wrote:
> On Mon, Jan 24, 2011 at 11:13:05PM -0500, Mark Lord wrote:
>> On 11-01-24 07:55 PM, Dmitry Torokhov wrote:
>>>
>>> No, as far as I know we kept ABI intact.
>>
>>
>> Okay, I hacked lsinput and input-kbd to ignore the protocol number.
>> input-kbd is still broken: it thinks my remote control (Hauppauge)
>> has only ten buttons, and won't allow me to remap codes larger than 10.
>>
>> I've now hacked around that too, but without determining exactly
>> where the interface got broken.
>>
>> Ugh.
>>
>
> Where are the sources? I can take a look...

I used "apt-get source input-utils" under Ubuntu-10.10.
The problem seems to be here somewhere:

static struct kbd_map* kbd_map_read(int fd)
{
        struct kbd_entry entry;
        struct kbd_map *map;
        int rc;

        map = malloc(sizeof(*map));
        memset(map,0,sizeof(*map));
        for (map->size = 0; map->size < 65536; map->size++) {
                entry.scancode = map->size;
                entry.keycode  = KEY_RESERVED;
                rc = ioctl(fd, EVIOCGKEYCODE, &entry);
                if (rc < 0) {
                        break;
                }
                if (map->size >= map->alloc) {
                        map->alloc += 64;
                        map->map = realloc(map->map, map->alloc * sizeof(entry));
                }
                map->map[map->size] = entry;

                if (KEY_RESERVED != entry.keycode)
                        map->keys++;
        }
        if (map->keys) {
                printf("map: %d keys, size: %d/%d\n",
                        map->keys, map->size, map->alloc);
                return map;
        } else {
                free(map);
                return NULL;
        }
}

This results in (map->size==10) for 2.6.36+ (wrong),
and a much larger map->size for 2.6.35 and earlier.

So perhaps EVIOCGKEYCODE has changed?

