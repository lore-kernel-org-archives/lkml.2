Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0HQFHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:07:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53298 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab0HQFH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:07:28 -0400
Message-ID: <4C6A1A2B.9080004@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 13:12:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
CC: Linux is full of bugs <linux-kernel@vger.kernel.org>,
        Nir Tzachar <nir.tzachar@gmail.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: BUG: nconfig doesn't preserve case in its menu display
References: <AANLkTimDmwmC3xDJVXB1LXJzMJTuamCswVeC5v42zU-Q@mail.gmail.com>	<4C69F7B9.2000103@cn.fujitsu.com> <AANLkTi==O7cKcM19iO=7XoZo3PndPBDctPy08NrbYSxx@mail.gmail.com>
In-Reply-To: <AANLkTi==O7cKcM19iO=7XoZo3PndPBDctPy08NrbYSxx@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ævar Arnfjörð Bjarmason wrote:
> On Tue, Aug 17, 2010 at 02:45, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> 于 2010年08月17日 05:04, Ævar Arnfjörð Bjarmason 写道:
>>> When I do "make nconfig" and go to "General Setup" my "Local version -
>>> append to kernel release" entry appears as:
>>>
>>>     (-avar-akbar) Local version - append to kernel release
>>>
>>> When I use "make menuconfig" it's:
>>>
>>>     (-Avar-Akbar) Local version - append to kernel release
>>>
>>> And my .config agrees:
>>>
>>>     $ ack -n1 CONFIG_LOCALVERSION .config
>>>     CONFIG_LOCALVERSION="-Avar-Akbar"
>>>
>>> But when I edit the version string in both menuconfig and nconfig it
>>> retains the correct casing.
>>>
>>> I briefly searched through the nconfig code, but couldn't find
>>> anything pertinent to the localversion, so this is probably a more
>>> general issue.
>> The bug is in make_hot(). Here is the fix:
> 
> That fixes the issue with strings inside (), but now e.g. "General
> setup" on the main screen will be "GEneral setup".
> 

Oops, I made a mistake. Try this one:

========================

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 13:08:13 +0800
Subject: [PATCH v2] nconfig: remember where to start searcing hot key

make_hot() skips '[...]', '<...>' and '(...)', but forgets to remember
where it starts to find the hot key, and then it makes all the letters
before the hot key lower case.

As a result, it shows:

    (-avar-akbar) Local version - append to kernel release
...
<m> Kernel .config support

When it should be:

    (-Avar-Akbar) Local version - append to kernel release
...
<M> Kernel .config support

Reported-by: Ævar Arnfjörð Bjarmason <avarab@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/nconf.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 2ba71bc..0bb7810 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -522,6 +522,7 @@ static int is_hot(int index)
 static int make_hot(char *dest, int len, const char *org, int index)
 {
 	int position = -1;
+	int start;
 	int i;
 	int tmp;
 	int c;
@@ -549,6 +550,7 @@ static int make_hot(char *dest, int len, const char *org, int index)
 	}
 	if (i == org_len)
 		return -1;
+	start = i;
 	for (; i < org_len; i++) {
 		if (canbhot(org[i]) && org[i-1] != '<' && org[i-1] != '(') {
 			position = i;
@@ -569,7 +571,7 @@ static int make_hot(char *dest, int len, const char *org, int index)
 	   */
 	/* make org[position] uppercase, and all leading letter small case */
 	strncpy(dest, org, len);
-	for (i = 0; i < position; i++)
+	for (i = start; i < position; i++)
 		dest[i] = tolower(dest[i]);
 	dest[position] = toupper(dest[position]);
 	k_menu_items[index].is_hot = 1;
-- 
1.6.3



