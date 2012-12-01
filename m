Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2LASuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:50:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52537 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2LASuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:50:03 -0500
Message-ID: <50BA515A.3020200@googlemail.com>
Date: Sat, 01 Dec 2012 19:50:02 +0100
From: Stefan Beller <stefanbeller@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Updating the .mailmap file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was just browsing the shortlog and it looked to 
me as if there are many double entries, i.e. the same person
being there with multiple email addresses.

So I wrote a script, which finds double names and adds them 
to the .mailmap file. However manual checking, whether these 
are really the same person is required.

---
#!/bin/bash

git shortlog -sne > shortlog.txt

# find double names in the shortlog
cat shortlog.txt |awk '{ NF--; $1=""; print }' |sort |uniq -d | sed 's/^ *//g' > names.txt

while read line
do
    echo "process name $line"
    # get the current mailmap file in a state where each person is listed
    # with their first line:
    rm mailmap_tmp*
    cat .mailmap |grep -v "^[# ]"|grep -v "^$" | sort > mailmap_tmp1
    while read <&9 line2
    do
        nameonly="$(echo "$line2" |awk '{NF--; print}')"
        grep -m1 "$nameonly" mailmap_tmp1 >> mailmap_tmp2
    done 9< "mailmap_tmp1"
    cat mailmap_tmp2 |uniq > mailmap_tmp3

    # find all occurences of one name
    cat shortlog.txt |grep "$line" | awk '{ $1=""; print }' | sed 's/^ *//g' > currentname.txt

    # get that guy alphabetically sorted into the mailmap file:
    echo $line > name
    cat mailmap_tmp3 name |sort > mailmap_tmp4

    # find the place where we need to insert this
    insertbeforeline=$(cat mailmap_tmp4 |grep -A1 "$line" |tail -n1)
    if [ "$insertbeforeline" != "" ] ; then
        # insert all in the middle of .mailmap:
        while read <&9 line2; do
            echo "adding line $line2 to mailmap before $insertbeforeline"
            sed "/$insertbeforeline/i $line2" .mailmap > mailmap_tmp5
            mv mailmap_tmp5 .mailmap
        done 9< "currentname.txt"
    else
        # must appended to end
        cat currentname.txt >> .mailmap
    fi

    git commit -a -m "Updating .mailmap file: Adding ${line}" > /dev/null
    echo "---"
done < "names.txt"

rm mailmap_tmp*
rm shortlog.txt
rm names.txt
