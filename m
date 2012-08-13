Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2HMVN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:13:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57712 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2HMVN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:13:56 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <20120813185817.GA17342@pengutronix.de>
References: <1344625575-27560-1-git-send-email-arnd@arndb.de>
	<20120813185817.GA17342@pengutronix.de>
Date: Mon, 13 Aug 2012 14:13:55 -0700
Message-ID: <CAOesGMjcSw1vUJ8nn4TakrRxEonryc=Oo-uhRxML=HwJpZQ8hQ@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] arm-soc updates
From: Olof Johansson <olof@lixom.net>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 11:58 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Arnd,
>
> On Fri, Aug 10, 2012 at 09:06:12PM +0200, Arnd Bergmann wrote:
>> Hi Linus,
>>
>> Here are three pull requests for you to consider for the next -rc.
>
> How do you send multiple pull requests? Is there some git foo available
> or do you do this manually?

For truly trivial multi-branch pulls, I just generate each
individually. For the merge windows we tend to have several branches
touching the same files, so diffstats would be harder to compare that
way.

So, this is my workflow. I think Arnd's is quite similar since my
script is based on an early version of what I got from him:

* Start a dummy branch based on latest upstream version
* For each branch to pull:
  - Merge in the branch to make sure you document/resolve conflicts
  - Generate pull request email (save to file)
  - Push resolved branch (if you want to provide that)
* Edit the saved pull requests to modify the x/y fields
* Send them (with git send-mail --annotate for cover letter)


I have a script that generates the pull-request email in a format that
git send-email accepts (i.e. it has a From/Subject header). It's not
very pretty, but for reference I included a copy below.


#!/bin/sh

# Usage: my-request-pull <tagname>, run from a branch that is checked out
# with the branch you wish to request pulled merged in as the top commit.

echo "From: $(git config --get user.name) <$(git config --get user.email)>"
echo -n Subject: [GIT PULL x/y]\
git tag -n20 -l $1 | sed -e 's:^[-a-z0-9]* *::g'

echo
echo "----------------------------------------------------------------"
echo

SHA=$(git log --pretty=oneline -1 HEAD~ | cut -d' ' -f 1)
DESC=$(git log --pretty=oneline -1 HEAD~ | cut -d' ' -f 1 --complement)

echo "The following changes since commit $SHA:"
echo
echo "  $DESC"
echo
echo "are available in the git repository at:"
echo
echo "  git://EDIT_YOUR_URL_IN_HERE tags/$1"
echo

SHA=$(git log --pretty=oneline -1 $1 | cut -d' ' -f 1)
DESC=$(git log --pretty=oneline -1 $1 | cut -d' ' -f 1 --complement)

echo "for you to fetch changes up to $SHA:"
echo
echo "  $DESC"
echo
echo "----------------------------------------------------------------"
echo

git shortlog HEAD~..$1
echo
git diff -M --stat=75 --summary HEAD~ | cat
